#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
cat <<EOF > /var/www/html/index.html
<html><body><h1>PCI</h1>
<p>This is a PCI Site!</p>
</body></html>
EOF
sudo service apache2 restart
