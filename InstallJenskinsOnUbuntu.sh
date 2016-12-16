#Auther: Phu.PQ
#Company: Soxes VietNam
#Email: phu@soxes.ch
#Skype: phu@soxes.ch
echo "--------------------------------------"
echo "|========== Install Jenkins ==========|"
echo "--------------------------------------"
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
echo 'deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get update
apt-get install jenkins
echo "|---------- Done ----------|"
