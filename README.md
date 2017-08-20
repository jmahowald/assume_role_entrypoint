This repo is meant to aid those using both docker and AWS
by automating the assumption of a role, either through convention via and AWS_ROLE_NAME environment variable, or through ECS.

It requires you to have bash,awscli,curl, and jq installed.

If you have AWS_ROLE defined then it will make an api call to sts to find out the account, then
to get new credentials. In then makes an api call and does an eval to set the new credentials in
the standard environment variables of `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY `


For ECS it follows the rules in here
http://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-iam-roles.html

and is looking for an env variable of `AWS_CONTAINER_CREDENTIALS_RELATIVE_URI` from which it 
can get a similar json doc as one get's when calling `aws sts assume role`


Hat tip to [https://github.com/Integralist/Shell-Scripts/blob/master/aws-cli-assumerole.sh](the original jq parsing script)


To use this, either just copy the contents into your entrypoint script or put the following in your dockerfile

```
ADD https://raw.githubusercontent.com/jmahowald/assume_role_entrypoint/master/aws_role_entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/aws_role_entrypoint.sh"]
```



