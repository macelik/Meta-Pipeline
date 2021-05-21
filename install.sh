#Install tools dependencies

sudo apt-get install -y build-essential
sudo apt-get install -y zip unzip

# Download Kraken and DB
dir=$(pwd)
mkdir installed_tools
mkdir Databases
wget -O Kraken2.zip https://github.com/DerrickWood/kraken2/archive/master.zip
unzip Kraken2.zip
mkdir /installed_tools/kraken
cd kraken2-master
./install_kraken2.sh $dir/installed_tools/kraken
cd ..
rm -r kraken2-master
wget ftp://ftp.ccb.jhu.edu/pub/data/kraken2_dbs/old/minikraken2_v2_8GB_201904.tgz
tar -xvf minikraken2_v2_8GB_201904.tgz -C Databases/
rm minikraken2_v2_8GB_201904.tgz
mv Databases/minikraken2_v2_8GB_201904_UPDATE/Databases/KrakenDB


#Set PATH for Kraken and DB
echo export PATH="$PATH:$dir/installed_tools/kraken/" >> ~/.bashrc
echo export KRAKEN2_DEFAULT_DB="$dir/Databases/KrakenDB" >> ~/.bashrc
##
echo dir=$dir >> ~/.bashrc

#Set PATH for Centrifuge and DB
wget https://github.com/DaehwanKimLab/centrifuge/archive/v1.0.4-beta.zip
wget https://genome-idx.s3.amazonaws.com/centrifuge/p%2Bh%2Bv.tar.gz
mkdir Databases/Centrifuge_DB
tar -xvf p+h+v.tar.gz -C Databases/Centrifuge_DB
unzip v1.0.4-beta.zip
rm v1.0.4-beta.zip
mv centrifuge-1.0.4-beta installed_tools/Centrifuge
cd $dir/installed_tools/Centrifuge
make
sudo make install prefix=/usr/local

#Set PATH for CLARK and DB
cd $dir
wget http://clark.cs.ucr.edu/Download/CLARKV1.2.6.1.tar.gz
tar -xvf CLARKV1.2.6.1.tar.gz -C installed_tools/
mv $dir/installed_tools/CLARKSCV1.2.6.1 $dir/installed_tools/Clark
cd $dir/installed_tools/Clark
./install.sh
mkdir $dir/Databases/Clark_DB
./set_targets.sh $dir/Databases/Clark_DB bacteria
echo export PATH="$PATH:$dir/installed_tools/Clark/" >> ~/.bashrc



