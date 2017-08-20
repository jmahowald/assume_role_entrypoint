#!/bin/bash

# Find the arn for the given logical role name, and calls sts assume role
sts_assume_role()
{
    role_name=$1
    acct_id=$(aws sts get-caller-identity --output text --query 'Account')
    role_doc=$(aws sts assume-role \
                    --role-arn "arn:aws:iam::$acct_id:role/$role_name" \
                    --role-session-name "$role_name")
    eval export AWS_ACCESS_KEY_ID=$(echo $role_doc | jq .Credentials.AccessKeyId | xargs)
    eval export AWS_SECRET_ACCESS_KEY=$(echo $role_doc | jq .Credentials.SecretAccessKey | xargs)
    eval export AWS_SESSION_TOKEN=$(echo $role_doc | jq .Credentials.SessionToken | xargs)
}

ecs_assume_role() {
    role_doc=$(curl 169.254.170.2$AWS_CONTAINER_CREDENTIALS_RELATIVE_URI)
    eval export AWS_ACCESS_KEY_ID=$(echo $role_doc | jq .AccessKeyId | xargs)
    eval export AWS_SECRET_ACCESS_KEY=$(echo $role_doc | jq .SecretAccessKey | xargs)
    eval export AWS_SESSION_TOKEN=$(echo $role_doc | jq .SessionToken | xargs)
}

if [[ ! -z $AWS_CONTAINER_CREDENTIALS_RELATIVE_URI ]]; then 
    echo "Found ecs role. getting credentials from $AWS_CONTAINER_CREDENTIALS_RELATIVE_URI"
    ecs_assume_role
elif [[ ! -z $AWS_ROLE_NAME ]]; then
    echo "Found aws role. Assuming $AWS_ROLE_NAME"
    sts_assume_role $AWS_ROLE_NAME
fi

exec "$@"

