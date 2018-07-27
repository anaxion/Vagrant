#!/usr/bin/bash -x
#
yum -y update
yum -y install httpd
systemctl enable httpd.service
systemctl start httpd.service
yum -y install postgresql-server postgresql-contrib
postgresql-setup initdb
echo "host        all      all      127.0.0.1/32        md5" > /var/lib/pgsql/9.6/data/pg_hba.conf
echo "host        all      all      ::1/128             md5" >> /var/lib/pgsql/9.6/data/pg_hba.conf
systemctl start postgresql
systemctl enable postgresql
yum -y install epel-release
systemctl restart httpd
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
yum install mod_php71w php71w-common php71w-mbstring php71w-xmlrpc php71w-soap php71w-gd php71w-xml php71w-intl php71w-mysqlnd php71w-cli php71w-mcrypt php71w-ldap -y
cd
yum install -y wget
wget https://download.moodle.org/download.php/direct/stable33/moodle-latest-33.tgz
sudo tar -zxvf moodle-latest-33.tgz -C /var/www/html
sudo chown -R root:root /var/www/html/moodle
sudo mkdir /var/moodledata
sudo chown -R apache:apache /var/moodledata
sudo chmod -R 755 /var/moodledata
systemctl restart httpd