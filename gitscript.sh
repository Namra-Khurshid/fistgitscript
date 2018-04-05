git clone https://github.com/openvswitch/ovs

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

install_ovs() {
sudo ./boot.sh
   sudo ./configure --prefix=/usr --localstatedir=/var --sysconfdir=/etc
   sudo make
   sudo make install
}

verify_installation() {
if [ $(ovs-vswitchd --version|wc -l) -eq 1 ]
   then
   echo "Installation Successful" > ~/installationfiles.txt
   configure_ovs
else
   echo "Installation Unsuccessful" > ~/installationfiles.txt
fi
}


configure_ovs(){
config_file="/etc/depmod.d/openvswitch.conf"
/sbin/modprobe openvswitch
apply_rules
}


apply_rules() {
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

if [ $(sudo ovs-ofctl dump-flows brdg1|wc -l) -eq 101 ]
then
   echo "Hundred Rules Applied Successfully"
else
   echo "Rules not applied"
fi
}

add_bridge() {
sudo ovs-vsctl add-br brdg1
ovs-vsctl add-port brdg1 ens4
ovs-vsctl add-port brdg1 ens5
}
