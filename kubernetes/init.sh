#!/bin/bash

action=$(echo $1| tr '[:upper:]' '[:lower:]')

function help {
    echo "Usage: $0 [create|delete]"
    exit 1
}

if [ "$#" -ne 1 ]; then
    echo "Wrong number of paramaters"
    help
fi

if [[ "$action" != "delete" && "$action" != "create" ]]; then
    echo "action=$action"
    echo "Wrong paramaters"
    help
fi

if [ "$action" == "delete" ]; then
    kubectl $action secret clairsecret
else
kubectl $action secret generic clairsecret --from-file=./config.yaml
fi

kubectl $action -f clair-kubernetes.yaml

exit 0