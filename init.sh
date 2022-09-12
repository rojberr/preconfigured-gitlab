#! /bin/bash
sudo apt-get update -qy
DEBIAN_FRONTEND=noniteractive apt-get -yq upgrade
sudo apt-get upgrade -qy 
sudo apt-get install -y curl ca-certificates tzdata perl dnsutils

echo "postfix postfix/mailname string example.com" | debconf-set-selections
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections
apt install -y postfix

curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash

GET_PRIV_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)

sudo EXTERNAL_URL="http://$GET_PRIV_IP/" apt-get install gitlab-ee -y