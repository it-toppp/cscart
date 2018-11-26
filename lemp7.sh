echo "Enter domain: "
read DOMAIN

#echo "Enter db password: "
#read DBPASS

#ansible
sudo add-apt-repository -y ppa:ansible/ansible-2.4
sudo apt-get -y update
sudo apt-get -y install git python-dev libffi-dev python-markupsafe libssl-dev
sudo apt-get -y install ansible mc wget 

mkdir ~/playbooks && git clone https://github.com/cscart/server-ansible-playbooks ~/playbooks
cp ~/playbooks/config/advanced.json  ~/playbooks/config/main.json
sed -i -e "s/"example.com"/${DOMAIN}/g" ~/playbooks/config/main.json
sed -i 's/"example.org", "example.ru"//' ~/playbooks/config/main.json

cd ~/playbooks/ && ansible-playbook -e @config/main.json -c local -i inventory_php7 lemp7.yml

wget "https://www.cs-cart.com/index.php?dispatch=pages.get_trial&page_id=297&edition=ultimate" -O cscart.zip
unzip cscart.zip -d /var/www/html/$DOMAIN/
#cd /var/www/html/$DOMAIN/
#chown -R service ./
#chmod 644 config.local.php
#chmod -R 755 design images var
#find design -type f -print0 | xargs -0 chmod 644
#find images -type f -print0 | xargs -0 chmod 644
#find var -type f -print0 | xargs -0 chmod 644

#phpmyadmin
apt install phpmyadmin -y
wget https://raw.githubusercontent.com/it-toppp/cscart/master/pma.conf -P /etc/nginx/sites-enabled
sed -i -e "s/"example.com"/${DOMAIN}/g" /etc/nginx/sites-enabled/pma.conf
systemctl restart nginx

#lets

echo "open in web browser    :  http://$DOMAIN
