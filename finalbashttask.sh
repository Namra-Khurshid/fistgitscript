#Clone git repository 
#git clone https://github.com/openvswitch/ovs

#Check for new commits
#checkfornewcommits

function checkfornewcommits() {
cd  ovs
git fetch
if [ $(git log HEAD..origin/master|wc -l) -eq 0 ]
then
   echo "no new commit found" > ~/modifiedfiles.txt
else
   echo "new commit found"  > ~/modifiedfiles.txt
   #update repo
   git pull
   install_ovs
   verify_installation
fi
}

#Install OVS
function install_ovs() {
   sudo apt install  autoconf -y
   sudo ./boot.sh
   sudo ./configure 
   sudo make
   sudo make install -y
}

#Verify the installation of ovs
function verify_installation() {
if [ $(ovs-vswitchd --version|wc -l) -eq 1 ]
   then
   echo "Installation Successful" > ~/installationfiles.txt
else
   echo "Installation Unsuccessful" > ~/installationfiles.txt
fi
}

#Apply hundred rules on OVS
function apply_rules() {
add_bridge

o1=10
o2=0
o3=0
o4=0

for i in {1..100}
do
   i="${o1}.${o2}.${o3}.${o4}"
   echo "$i"
   sudo ovs-ofctl add-flow brdg1 in_port=1,ip,priority=1,nw_src="$i",actions=output:2
   o4=$((o4+1))
done

#Verify hundred rules on ovs
if [ $(sudo ovs-ofctl dump-flows brdg1|wc -l) -eq 101 ]
then
   echo "Hundred Rules Applied Successfully"
else
   echo "Rules not applied"
fi
}

#Check if apache is installed or not
function check_webserver() {
connection_status=$(telnet localhost 80|sed -n '2p')
exit

if [ "$connection_status" == "Connected to localhost." ]
then 
  echo "Web Server is installed"
else 
  echo "Server not installed"
fi
}

#Install Apache Web Server
function install_webserver() {
sudo apt-get update
sudo apt-get install apache2 -y
sudo service apache2 start
}

#Create an html page
function create_htmlpage() {
sudo sh -c " echo '<h1>Bash Script Task</h1>' >  /var/www/html/ovsstatus.html"
sudo chmod 777 ovsstatus.html
exit
}

#Update html page
function update_page() {
cd ovs

hash=$(git log -1| sed -n '1p')
date_time=$(git log -1| sed -n '3p')

status=" '<h2>${date_time} OVS commit ${hash} Successful</h2>' "
sudo sh -c " echo $status >> /var/www/html/ovsstatus.html "
echo "$status"
}


