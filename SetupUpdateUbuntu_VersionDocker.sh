#Auther: Phu.PQ
#Company: Soxes VietNam
#Email: phu@soxes.ch
#Skype: phu@soxes.ch

echo "|-------------------------|"
echo "|======Update UBUNTU======|"
echo "|-------------------------|"
apt-get update
apt-get -y upgrade
echo "|-------------------------------------|"
echo "|==== Install Python Development  ====|"
echo "|-------------------------------------|"
apt-get -y install build-essential python-dev libsqlite3-dev libreadline6-dev libgdbm-dev zlib1g-dev libbz2-dev sqlite3 zip libssl-dev
echo "|--------------------------------|"
echo "|==== Install Python modules ====|"
echo "|--------------------------------|"
apt-get -y install python-pip
pip install pyeapi
pip install jsonrpc
sudo easy_install stripe
echo "|------------------------------------------------|"
echo "|==== Insntall MySQL Server and MySQL Client ====|"
echo "|------------------------------------------------|"
apt-get -y install mysql-server mysql-client
echo "|------------------------|"
echo "|==== Install Apache ====|"
echo "|------------------------|"
apt-get -y install apache2
apt-get -y install libapache2-mod-wsgi
a2enmod wsgi
a2enmod ssl
a2enmod proxy
a2enmod proxy_http
a2enmod headers
a2enmod expires
a2enmod rewrite
echo "|--------------------------------|"
echo "|==== Create SSL Certificate ====|"
echo "|--------------------------------|"
mkdir /etc/apache2/ssl
sh -c 'openssl genrsa 1024 > /etc/apache2/ssl/self_signed.key'
chmod 400 /etc/apache2/ssl/self_signed.key
sh -c 'openssl req -new -x509 -nodes -sha1 -days 365 -key /etc/apache2/ssl/self_signed.key > /etc/apache2/ssl/self_signed.cert'
sh -c 'sudo openssl x509 -noout -fingerprint -text < /etc/apache2/ssl/self_signed.cert > /etc/apache2/ssl/self_signed.info'
#echo "|---------------------|"
#echo "|==== Install SVN ====|"
#echo "|---------------------|"
#apt-get -y install subversion
echo "|------------------------|"
echo "|==== Install Web2Py ====|"
echo "|------------------------|"
cd /home/www-data
mkdir web2py
#mkdir www-data
#cd www-data
#svn co https://repo.soxes.ch/svn/mykpi/root/src/web2py
chown -R www-data:www-data web2py
echo "|-------------------------------------------|"
echo "|==== Configure Apache to use mod_wsgi  ====|"
echo "|-------------------------------------------|"
cd /etc/apache2/sites-available/
echo '
WSGIDaemonProcess web2py user=www-data group=www-data 

<VirtualHost *:80>

  RewriteEngine On
  RewriteCond %{HTTPS} !=on
  RewriteRule ^/?(.*) https://%{SERVER_NAME}/$1 [R,L]

  CustomLog /var/log/apache2/access.log common
  ErrorLog /var/log/apache2/error.log
</VirtualHost>

<VirtualHost *:443>
  SSLEngine on
  SSLCertificateFile /etc/apache2/ssl/self_signed.cert
  SSLCertificateKeyFile /etc/apache2/ssl/self_signed.key

  WSGIProcessGroup web2py
  WSGIScriptAlias / /home/www-data/web2py/wsgihandler.py
  WSGIPassAuthorization On

  <Directory /home/www-data/web2py>
    AllowOverride None
    Require all denied
    <Files wsgihandler.py>
      Require all granted
    </Files>
  </Directory>

  AliasMatch ^/([^/]+)/static/(?:_[\d]+.[\d]+.[\d]+/)?(.*) \
        /home/www-data/web2py/applications/$1/static/$2

  <Directory /home/www-data/web2py/applications/*/static/>
    Options -Indexes
    ExpiresActive On
    ExpiresDefault "access plus 1 hour"
    Require all granted
  </Directory>

  CustomLog /var/log/apache2/ssl-access.log common
  ErrorLog /var/log/apache2/error.log
</VirtualHost> 
' > /etc/apache2/sites-available/web2py.conf
sudo rm /etc/apache2/site-enabled/*
sudo a2ensite web2py
service apache2 restart
echo "|------------------------------|"
echo "|==== Start Web2Py Service ====|"
echo "|------------------------------|"
cd /home/www-data/web2py/
sudo -u www-data python -c "from gluon.widget import console; console();"
sudo -u www-data python -c "from gluon.main import save_password; save_password(raw_input('admin password: '),443)"
echo "======== DONE =========="



