#/bin/sh

# for django 4.0
GEOS_VERSION=3.10.3
PROJ_VERSION=8.2.1
PROJ_DATA_VERSION=1.10
GDAL_VERSION=3.3.3
SQLITE_VERSION=3390200

# node_modules/.bin/tsc

rm -rf ./temp
mkdir -p ./temp
cd ./temp

yum install -y tar bzip2 which make gcc gcc-c++ util-linux wget pkgconfig libtiff-devel

wget -O cmake-install https://github.com/Kitware/CMake/releases/download/v3.13.0/cmake-3.13.0-Linux-x86_64.sh
sh cmake-install --skip-license --prefix=/usr --exclude-subdirectory

# Build GEOS
wget https://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2
tar xjf geos-${GEOS_VERSION}.tar.bz2
cd geos-${GEOS_VERSION}
./configure
make -j8
cd ..

# sqlite dependency
wget https://www.sqlite.org/2022/sqlite-autoconf-${SQLITE_VERSION}.tar.gz
tar xzf sqlite-autoconf-${SQLITE_VERSION}.tar.gz
cd sqlite-autoconf-${SQLITE_VERSION}
./configure
make -j8
cd ..

# Build PROJ.4
wget https://download.osgeo.org/proj/proj-${PROJ_VERSION}.tar.gz
wget https://download.osgeo.org/proj/proj-data-${PROJ_DATA_VERSION}.tar.gz
tar xzf proj-${PROJ_VERSION}.tar.gz
cd proj-${PROJ_VERSION}/data
tar xzf ../../proj-data-${PROJ_DATA_VERSION}.tar.gz
cd ..
PKG_CONFIG_PATH=../sqlite-autoconf-${SQLITE_VERSION} ./configure --without-curl
make -j8
cp -r src/.libs lib
cd ..

# Build GDAL
wget https://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz
tar xzf gdal-${GDAL_VERSION}.tar.gz
cd gdal-${GDAL_VERSION}
CPPFLAGS=-I$(pwd)/../proj-${PROJ_VERSION}/src LDFLAGS=-L$(pwd)/../proj-${PROJ_VERSION}/src/.libs ./configure \
  --with-hide-internal-symbols \
  --with-lerc=no \
  --with-pcraster=no \
  --with-qhull=no \
  --with-png=no \
  --with-jpeg=no \
  --with-gif=no \
  --disable-all-optional-drivers
make -j8
