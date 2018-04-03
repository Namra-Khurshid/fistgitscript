git clone https://github.com/openvswitch/ovs

cd ovs

if [ $(git ls-files -m|wc -l) -eq 0 ]
then
   echo "nooo modified files found"
else
   git ls-files -m|wc -l
   echo "modified files found"
   rm -rf ovs
   git clone https://github.com/openvswitch/ovs
  #sudo apt-get install openvswitch-switch
   ./boot.sh
   ./configure --with-linux=/lib/modules/`uname -r`/build
   make 
   sudo make install
 
   if [ $(sudo apt list --installed| grep openvswitch|wc -l) != "0" ]
   then
   echo "Installation Successful"
   else
   echo "Installation Unsuccessful"
   fi
fi

