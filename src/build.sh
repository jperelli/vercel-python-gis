yum repolist
cat /etc/lsb-release
yum install -y epel-release
yum install -y geos proj gdal

# Install GEOS
# wget http://download.osgeo.org/geos/geos-3.4.2.tar.bz2
# tar xjf geos-3.4.2.tar.bz2
# cd geos-3.4.2
# ./configure
# make
# sudo make install
# cd ..

# # Install PROJ.4
# wget http://download.osgeo.org/proj/proj-4.9.1.tar.gz
# wget http://download.osgeo.org/proj/proj-datumgrid-1.5.tar.gz
# tar xzf proj-4.9.1.tar.gz
# cd proj-4.9.1/nad
# tar xzf ../../proj-datumgrid-1.5.tar.gz
# cd ..
# ./configure
# make
# sudo make install
# cd ..

# sudo yum-config-manager --enable epel
# sudo yum -y update
# ** All one command; copy from 'sudo' to 'automake'
# sudo yum install make automake gcc gcc-c++ libcurl-devel proj-devel geos-devel autoconf automake gdal
# cd /tmp
# ** All one command; copy from 'curl' to 'zxf -'
# curl -L http://download.osgeo.org/gdal/2.2.3/gdal-2.2.3.tar.gz | tar zxf -
# cd gdal-2.2.3/
# ./configure --prefix=/usr/local --without-python
# ** next command will take a while on a t2.micro
# make -j4
# sudo make install
# cd /usr/local
# tar zcvf ~/gdal-2.2.3-amz1.tar.gz *
