#!/bin/sh

# files available
# ./files/libjbig.so.2.0
# ./files/libjpeg.so.62.3.0
# ./files/libtiff.so.5.2.0
# ./files/libgeos.so.3.10.3
# ./files/libgdal.so.29.0.3
# ./files/libproj.so.22.2.1
# ./files/libsqlite3.so.0.8.6

# files to create
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

cp ./files/libjbig.so.2.0 /lib64/libjbig.so.2.0
cp ./files/libjpeg.so.62.3.0 /lib64/libjpeg.so.62.3.0
ln -s /lib64/libjpeg.so.62.3.0 /lib64/libjpeg.so.62
cp ./files/libtiff.so.5.2.0 /lib64/libtiff.so.5.2.0
ln -s /lib64/libtiff.so.5.2.0 /lib64/libtiff.so.5
ln -s /lib64/libtiff.so.5.2.0 /lib64/libtiff.so
cp ./files/libgeos.so.3.10.3 /usr/local/lib64/libgeos.so.3.10.3
ln -s /usr/local/lib64/libgeos.so.3.10.3 /usr/local/lib64/libgeos.so
cp ./files/libgdal.so.29.0.3 /usr/local/lib/libgdal.so.29.0.3
ln -s /usr/local/lib/libgdal.so.29.0.3 /usr/local/lib/libgdal.so.29
ln -s /usr/local/lib/libgdal.so.29.0.3 /usr/local/lib/libgdal.so
cp ./files/libproj.so.22.2.1 /usr/local/lib/libproj.so.22.2.1
ln -s /usr/local/lib/libproj.so.22.2.1 /usr/local/lib/libproj.so.22
ln -s /usr/local/lib/libproj.so.22.2.1 /usr/local/lib/libproj.so
cp ./files/libsqlite3.so.0.8.6 /usr/local/lib/libsqlite3.so.0.8.6
ln -s /usr/local/lib/libsqlite3.so.0.8.6 /usr/local/lib/libsqlite3.so.0
ln -s /usr/local/lib/libsqlite3.so.0.8.6 /usr/local/lib/libsqlite3.so
