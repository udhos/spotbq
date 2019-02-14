#!/bin/bash

msg() {
	echo 1>&2 $0: $*
}

die() {
	msg $*
	exit 1
}

cat <<__EOF__
PROJECT_ID=$PROJECT_ID
DATASET=$DATASET
TABLE=$TABLE
__EOF__

[ -z "$PROJECT_ID" ] && die missing PROJECT_ID
[ -z "$DATASET" ] && die missing DATASET
[ -z "$TABLE" ] && die missing TABLE

tmp=/tmp/eraseme

id=$(curl -s http://169.254.169.254/latest/meta-data/instance-id || curl meta-data failure)

[[ $id = i-* ]] || msg bad instanceid=$id

msg instanceid=$id

aws ec2 describe-instances --region sa-east-1 --instance-ids $id > $tmp || msg describe-instances failure

lifecycle=$(jq -r '.Reservations[0].Instances[0].InstanceLifecycle' < $tmp || msg jq lifecycle failure)

msg lifecycle=$lifecycle

if [ "$lifecycle" != spot ]; then
	lifecycle=non-spot
fi

upload() {
	local m="$*"
	# YYYY-[M]M-[D]D[( |T)[H]H:[M]M:[S]S
	now=$(date +'%Y-%m-%d %H:%M:%S') 
	printf "\"$now\",\"$id\",\"$lifecycle\",\"$m\"\n" > data.csv
	cat data.csv
	bq load --source_format=CSV $PROJECT_ID:$DATASET.$TABLE data.csv schema.json
}

upload boot

while :; do
	sleep 5
	upload ping
done
