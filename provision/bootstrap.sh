#!/bin/bash
#set -vxn

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

curl -sSL https://get.docker.com/ | CHANNEL=stable bash
systemctl enable --now docker

DOMAIN="${domain}"

if [ -z "$DOMAIN" ]; then
    snap install --classic certbot
    certbot certonly --standalone --agree-tos --email abance@bancey.xyz --no-eff-email --non-interactive -d "$DOMAIN"
fi

mkdir -p /etc/pterodactyl
curl -L -o /usr/local/bin/wings "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_$([[ "$(uname -m)" == "x86_64" ]] && echo "amd64" || echo "arm64")"
chmod u+x /usr/local/bin/wings

curl -L -o /etc/systemd/system/wings.service "https://github.com/bancey/terraform-module-pterodactyl-node/blob/a8218ae0c87f81fb43b7dce54ae85264c09eb5ad/provision/wings.service"
systemctl enable wings
