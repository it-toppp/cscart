echo "Enter domain: "
read DOMAIN

#echo "Enter db password: "
#read DBPASS

#ansible
sudo add-apt-repository -y ppa:ansible/ansible-2.4
sudo apt-get -y update
sudo apt-get -y install git python-dev libffi-dev python-markupsafe libssl-dev
sudo apt-get -y install ansible mc curl wget git

mkdir ~/playbooks && git clone https://github.com/cscart/server-ansible-playbooks ~/playbooks
cp ~/playbooks/config/advanced.json  ~/playbooks/config/main.json
sed -i -e "s/"example.com"/${DOMAIN}/g" ~/playbooks/config/main.json
sed -i 's/"example.org", "example.ru"//' ~/playbooks/config/main.json

cd ~/playbooks/ && ansible-playbook -e @config/main.json -c local -i inventory_php7 lemp7.yml

wget "https://www.cs-cart.com/index.php?dispatch=pages.get_trial&page_id=297&edition=ultimate" -O /var/www/html/$DOMAIN/cscart.zip

#phpmyadmin
apt install phpmyadmin -y
wget https://raw.githubusercontent.com/it-toppp/cscart/master/pma.conf -P /etc/nginx/sites-enabled
sed -i -e "s/"example.com"/${DOMAIN}/g" /etc/nginx/sites-enabled/pma.conf
systemctl restart nginx

#lets
