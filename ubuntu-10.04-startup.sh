#!/bin/bash
# Initially developed by Norman Richards for Ringful Health
# inspired by http://allanfeid.com/content/using-amazons-cloudformation-cloud-init-chef-and-fog-automate-infrastructure

if [ -d /etc/profile.d ]; then
  for i in /etc/profile.d/*.sh; do
    if [ -r $i ]; then
      . $i
    fi
  done
  unset i
fi

if [ "$PS1" ]; then
  if [ "$BASH" ]; then
    PS1='\u@\h:\w\$ '
    if [ -f /etc/bash.bashrc ]; then
        . /etc/bash.bashrc
    fi
  else
    if [ "`id -u`" -eq 0 ]; then
      PS1='# '
    else
      PS1='$ '
    fi
  fi
fi

umask 022

PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games"
HOME="/root"

log='/tmp/init.log'
apt-get update &>> $log
apt-get install -y ruby ruby1.8-dev build-essential wget libruby-extras libruby1.8-extras git-core &>> $log
cd /tmp
wget http://production.cf.rubygems.org/rubygems/rubygems-1.3.7.tgz &>> $log
tar zxf rubygems-1.3.7.tgz &>> $log
cd rubygems-1.3.7
ruby setup.rb --no-format-executable &>> $log
gem install ohai chef --no-rdoc --no-ri --verbose &>> $log

mkdir -p /var/chef/cache
mkdir -p /opt/pophealth-chef
git clone https://github.com/ringful/pophealth-chef.git /opt/pophealth-chef &>> $log
ln -s /opt/pophealth-chef/cookbooks /var/chef/cookbooks
ln -s /opt/pophealth-chef/roles /var/chef/roles 
mkdir /etc/chef

cat <<EOF > /etc/chef/solo.rb
file_cache_path "/var/chef/cache"
cookbook_path "/var/chef/cookbooks"
role_path "/var/chef/roles"
json_attribs "/etc/chef/node.json"
log_location "/var/chef/solo.log"
verbose_logging true
EOF

cat <<EOF > /etc/chef/node.json
{
  "run_list": [ 
    "role[pophealth]"
  ]
}
EOF

chef-solo &>> $log
