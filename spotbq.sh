#!/bin/bash

msg() {
	echo 1>&2 $0: $*
}

die() {
	msg $*
	exit 1
}

tmp=/tmp/eraseme

id=$(curl http://169.254.169.254/latest/meta-data/instance-id || curl meta-data failure)

[[ $id = i-* ]] || msg bad instanceid=$id

msg instanceid=$id

aws ec2 describe-instances --region sa-east-1 --instance-ids $id > $tmp || msg describe-instances failure

lifecycle=$(jq -r '.Reservations[0].Instances[0].InstanceLifecycle' < $tmp || msg jq lifecycle failure)

msg lifecycle=$lifecycle
