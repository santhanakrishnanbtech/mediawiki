#!/usr/bin/env bash

set -x

echo "Installing Concourse CI"

CONCOURSE=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
#----------------------------------------------------------------------------------------------------[ INSTALL PreRequisites ]
amazon-linux-extras install docker nginx1 -y
yum install git -y
systemctl start docker
systemctl start nginx
systemctl enable docker
systemctl enable nginx
usermod -aG docker ec2-user
curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose
#----------------------------------------------------------------------------------------------------[ CONFIG Concourse ]
mkdir -p /concourse
cd /concourse
curl -L https://concourse-ci.org/docker-compose.yml -o docker-compose.yml
sed -i 's+CONCOURSE_EXTERNAL_URL: http://localhost:8080+CONCOURSE_EXTERNAL_URL: http://'$CONCOURSE':81+g' docker-compose.yml
sed -i 's+CONCOURSE_ADD_LOCAL_USER: test:test+CONCOURSE_ADD_LOCAL_USER: admin:P@ssw0rd+g' docker-compose.yml
sed -i 's+CONCOURSE_MAIN_TEAM_LOCAL_USER: test+CONCOURSE_MAIN_TEAM_LOCAL_USER: admin+g' docker-compose.yml

#----------------------------------------------------------------------------------------------------[ DEPLOY ConcourseCI ]
docker-compose up -d
sleep 5s
#----------------------------------------------------------------------------------------------------[ CONFIG Nginx ]
cat <<EOF | tee /etc/nginx/nginx.conf
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;
include /usr/share/nginx/modules/*.conf;
events {
    worker_connections 1024;
}
http {
    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';
    access_log  /var/log/nginx/access.log  main;
    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 4096;
    #client_max_body_size 1000M;
    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;
    include /etc/nginx/conf.d/*.conf;
    server {
        listen       81;
        listen       [::]:81;
        server_name  _;
        location / {
                    proxy_pass http://127.0.0.1:8080;
        }
    }
        server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        location / {
            proxy_set_header   X-Forwarded-For \$remote_addr;
            proxy_set_header   Host \$http_host;
            proxy_pass http://10.0.2.11:80;
        }

        if (\$http_host = 10.0.2.11) {
            rewrite (.*) http://$CONCOURSE$1;
        }
    }
}
EOF
nginx -t
systemctl reload nginx

#----------------------------------------------------------------------------------------------------[ INSTALL FlyCLI ]
curl -# -o fly "http://localhost:8080/api/v1/cli?arch=amd64&platform=linux"
chmod +x fly && mv fly /usr/bin/

#fly -t main login --concourse-url http://$CONCOURSE:81 -u admin -p P@ssw0rd
#fly -t main sync

# Creating the first pipeline
#git clone https://github.com/santhanakrishnanbtech/mediawiki.git
#cd mediawiki/ci/pipelines/
#fly -t ci sp -p app-server -c hello.yml -n
#fly -t ci sp -p db-server -c hello.yml -n

