#!/bin/bash

msg() {
	echo 1>&2 $0: $*
}

die() {
	msg $*
	exit 1
}

msg $0 version 0.1
msg user: $(id)

schema=schema.json

[ -z "$SCHEMA" ] && SCHEMA=$schema

cat <<__EOF__
PROJECT_ID=$PROJECT_ID
DATASET=$DATASET
TABLE=$TABLE
DRY=$DRY
SCHEMA=$SCHEMA
__EOF__

[ -r "$SCHEMA" ] || die missing schema file $SCHEMA

dry_run() {
	[ -n "$DRY" ]
}

[ -z "$PROJECT_ID" ] && die missing PROJECT_ID
[ -z "$DATASET" ] && die missing DATASET
[ -z "$TABLE" ] && die missing TABLE
dry_run && msg DRY mode

tmpid=/tmp/eraseme
tmpcsv=/tmp/data.csv

id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id || curl meta-data failure)

[[ $id = i-* ]] || msg bad instanceid=$id

msg instanceid=$id

aws ec2 describe-instances --region sa-east-1 --instance-ids $id > $tmpid || msg describe-instances failure

lifecycle=$(jq -r '.Reservations[0].Instances[0].InstanceLifecycle' < $tmpid || msg jq lifecycle failure)

msg lifecycle=$lifecycle

if [ "$lifecycle" != spot ]; then
	lifecycle=non-spot
fi

upload() {
	local m="$*"
	# YYYY-[M]M-[D]D[( |T)[H]H:[M]M:[S]S
	now=$(date +'%Y-%m-%d %H:%M:%S') 
	printf "\"$now\",\"$id\",\"$lifecycle\",\"$m\"\n" > $tmpcsv
	bigquery=~/google-cloud-sdk/bin/bq
	cmd="$bigquery load --source_format=CSV $PROJECT_ID:$DATASET.$TABLE $tmpcsv $SCHEMA"
	if dry_run; then
		msg DRY mode, data.csv is:
		cat $tmpcsv
		msg DRY mode, skipping: $cmd
	else
		$cmd
	fi
}

upload boot

while :; do
	sleep 600
	upload ping
done

