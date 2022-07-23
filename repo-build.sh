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
make install
cd ..

# sqlite dependency
wget https://www.sqlite.org/2022/sqlite-autoconf-${SQLITE_VERSION}.tar.gz
tar xzf sqlite-autoconf-${SQLITE_VERSION}.tar.gz
cd sqlite-autoconf-${SQLITE_VERSION}
./configure
make -j8
make install
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
make install
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
make install


## ldd dependency tree
# /usr/local/lib/libgdal.so.29.0.3
#   /usr/local/lib/libsqlite3.so.0.8.6
#   /lib64/libtiff.so.5
#     /lib64/libjbig.so.2.0
#     /lib64/libjpeg.so.62
#   /usr/local/lib64/libgeos_c.so.1
# /usr/local/lib/libproj.so.22.2.1
# /usr/local/lib64/libgeos.so.3.10.3

## ls -l gives
# /lib64/libjbig.so.2.0
# /lib64/libjpeg.so.62.3.0
# /lib64/libjpeg.so.62 -> libjpeg.so.62.3.0
# /lib64/libtiff.so.5.2.0
# /lib64/libtiff.so.5 -> libtiff.so.5.2.0
# /lib64/libtiff.so -> libtiff.so.5.2.0
# /usr/local/lib64/libgeos.so.3.10.3
# /usr/local/lib64/libgeos.so -> libgeos.so.3.10.3
# /usr/local/lib/libgdal.so.29.0.3
# /usr/local/lib/libgdal.so.29 -> libgdal.so.29.0.3
# /usr/local/lib/libgdal.so -> libgdal.so.29.0.3
# /usr/local/lib/libproj.so.22.2.1
# /usr/local/lib/libproj.so.22 -> libproj.so.22.2.1
# /usr/local/lib/libproj.so -> libproj.so.22.2.1
# /usr/local/lib/libsqlite3.so.0.8.6
# /usr/local/lib/libsqlite3.so.0 -> libsqlite3.so.0.8.6
# /usr/local/lib/libsqlite3.so -> libsqlite3.so.0.8.6

# copy installed relevant libraries to outside of the container
cp /lib64/libjbig.so.2.0 \
/lib64/libjpeg.so.62.3.0 \
/lib64/libtiff.so.5.2.0 \
/usr/local/lib64/libgeos_c.so.1.16.1 \
/usr/local/lib64/libgeos.so.3.10.3 \
/usr/local/lib/libgdal.so.29.0.3 \
/usr/local/lib/libproj.so.22.2.1 \
/usr/local/lib/libsqlite3.so.0.8.6 \
files

# remove versions so that LD_LIBRARY_PATH find them
mv files/libgdal.so.29.0.3    files/libgdal.so
mv files/libgeos_c.so.1.16.1  files/libgeos_c.so.1
mv files/libgeos.so.3.10.3    files/libgeos.so.3.10.3
mv files/libjbig.so.2.0       files/libjbig.so.2.0
mv files/libjpeg.so.62.3.0    files/libjpeg.so.62
mv files/libproj.so.22.2.1    files/libproj.so.22
mv files/libsqlite3.so.0.8.6  files/libsqlite3.so.0.8.6
mv files/libtiff.so.5.2.0     files/libtiff.so.5

for f in files/*; do strip --strip-debug $f -o stripped-$f; done

du -sh stripped-files/* | sort -hr

du -sh stripped-files
