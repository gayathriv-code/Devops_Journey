sudo apt-get update
sudo apt-get install apache2

sudo systemctl start apache2
sudo systemctl enable apache2

sudo echo "<html><body><h1>hello world<h1><body><html>" | sudo tee /var/www/html/index.html


sudo systemctl restart apache2