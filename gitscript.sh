
git clone https://github.com/openvswitch/ovs

#git clone https://github.com/Namra-Khurshid/fistgitscript

cd  ovs
git fetch

if [ $(git log HEAD..origin/master|wc -l) -eq 0 ]
then
   echo "no new commit found" > ~/modifiedfiles.txt   
else
   echo "new commit found"  > ~/modifiedfiles.txt
   git pull
   sudo ./boot.sh
   sudo ./configure 
   sudo make 
   sudo make install
   if [ $(ovs-vswitchd --version|wc -l) -eq 1 ]
   then
   echo "Installation Successful" > ~/installationfiles.txt
   else
   echo "Installation Unsuccessful" > ~/installationfiles.txt
   fi
fi

