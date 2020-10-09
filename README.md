# MediaWiki
Automation of MediaWiki Installation
## Getting Started
These instructions will get you a copy of the project up and running on AWS Cloud for development and testing purposes. 
See deployment for notes on how to deploy the project on a live system.
### Prerequisites
```
Git
terraform 0.12.0
intellij idea (optional)
MobaXtreme (optional)

awscli (configured with default aws account)
```
#### Installing
> A step by step series of examples that tell you how to get a development env running
#### Code
```
git clone https://github.com/santhanakrishnanbtech/mediawiki.git
cd mediawiki
``` 
>#### Infrastructure with Terraform
>#### Architecture
![Alt Text](.images/architecture.png "Image Title")
```
cd terraform/env/dev/
terraform init
terraform plan -out=tfplan -input=false
terraform show tfplan # (optional)
terraform apply -input=false tfplan
```
#### Output
```
concourse_ip = <PUBLICIP> # make note of publicip
```
>#### Configuring CI
> Login to CONCOURSE server with output ip in previous step

![Alt Text](.images/concourse.png "Image Title")

>#### Install `FLY CLI`
```
curl -# -o fly "http://<PUBLICIP>:81/api/v1/cli?arch=amd64&platform=linux"
chmod +x fly
mv fly /usr/bin
fly -t main login --concourse-url http://<PUBLICIP>:81 -u admin -p P@ssw0rd
fly -t main sync
```
>#### Configure Pipelines
```
cd mediawiki/ci/
cat <<EOF | tee credentials.yml
github-url: https://github.com/santhanakrishnanbtech/mediawiki.git
pem-key: |
  -----BEGIN RSA PRIVATE KEY-----
  -----END RSA PRIVATE KEY-----
EOF
fly -t main sp -p Infra -c pipeline.yml -l credentials.yml -n
```
![Alt Text](.images/pipeline01.png "Image Title")
```
fly -t main unpause-pipeline -p infra
```
Concourse will start provisioning the servers
![Alt Text](.images/pipeline02.png "Image Title")
#### Configure MediaWiki

> Open public with port `80`

![Alt Text](.images/app01.png "Image Title")

> Follow below steps to configure

![Alt Text](.images/app02.png "Image Title")

*Continue*

![Alt Text](.images/app03.png "Image Title")

*Provide DB Server details and Continue*

![Alt Text](.images/app04.png "Image Title")

*Continue*

![Alt Text](.images/app05.png "Image Title")

*Provide Wiki Namespace Continue*

![Alt Text](.images/app06.png "Image Title")

*Continue*

![Alt Text](.images/app07.png "Image Title")

*Continue*

![Alt Text](.images/app09.png "Image Title")

 Download the `LocalSettings.php` and upload to `web_server` - location `/var/www/mediawiki/`

![Alt Text](.images/app10.png "Image Title")

*Login*

![Alt Text](.images/app11.png "Image Title")
![Alt Text](.images/app12.png "Image Title")

> We have successfully provisioned mediawiki

### Personal Notes
> `Concourse CI` login can be secured with `OATH github` login

> Need a `backend state` store check ```terraform/env/dev/run.sh```

> To secure `credential.yml` we can put the pem_key in s3 bucket and call with below in concourse pipeline.
```
resources:
- name: keys
    type: s3-resource-simple
    source:
      bucket: mediawiki-ci-artifacts
      path: concourse_vars/
      region: ap-south-1
```

> Servers are in private subnet so user bastion host.
```
Host concourse
  User         ec2-user
  HostName     PUBLICIP
  IdentityFile ~/PROD002.pem

Host web
  User          ec2-user
  HostName      10.0.2.11
  IdentityFile  ~/PROD002.pem
  ProxyCommand ssh concourse -W %h:%p

Host 10.0.2.11
  User          ec2-user
  HostName      10.0.2.11
  IdentityFile  ~/PROD002.pem
  ProxyCommand ssh concourse -W %h:%p
```





