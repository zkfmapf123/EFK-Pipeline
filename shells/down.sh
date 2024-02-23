#!/bin/bash

tags=("kibana" "master" "slave-1" "slave-2")

for tag in "${tags[@]}"; do
    ip=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=${tag}" | jq -r ".Reservations[].Instances[].InstanceId"); 
    aws ec2 stop-instances --instance-ids ${ip}
done