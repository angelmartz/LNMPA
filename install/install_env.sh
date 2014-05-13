#! /bin/sh

# Fix path for some servers
export PATH=/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:~/bin
# Load functions
. ${LNMPA_PATH}/functions

if [ ! $(grep -l '/lib'    '/etc/ld.so.conf') ]; then
	echo "/lib" >> /etc/ld.so.conf
fi

if [ ! $(grep -l '/usr/lib'    '/etc/ld.so.conf') ]; then
	echo "/usr/lib" >> /etc/ld.so.conf
fi

if [ ! $(grep -l '/usr/local/lib'    '/etc/ld.so.conf') ]; then
	echo "/usr/local/lib" >> /etc/ld.so.conf
fi

ldconfig


# Stable packages
Downloadfile lib-web/autoconf/${autoconf_dir}.tar.gz
./configure --prefix=/usr/local/${autoconf_dir}
make
make install


Downloadfile lib-web/libiconv/${libiconv_dir}.tar.gz
./configure
make
make install


Downloadfile lib-web/libmcrypt/${libmcrypt_dir}.tar.gz
./configure --disable-posix-threads
make
make install
ldconfig
cd libltdl/
./configure --enable-ltdl-install
make
make install


Downloadfile lib-web/mhash/${mhash_dir}.tar.gz
./configure
make
make install


ln -s /usr/local/lib/libmcrypt.la /usr/lib/libmcrypt.la
ln -s /usr/local/lib/libmcrypt.so /usr/lib/libmcrypt.so
ln -s /usr/local/lib/libmcrypt.so.4 /usr/lib/libmcrypt.so.4
ln -s /usr/local/lib/libmcrypt.so.4.4.8 /usr/lib/libmcrypt.so.4.4.8
ln -s /usr/local/bin/libmcrypt-config /usr/bin/libmcrypt-config
ln -s /usr/local/lib/libmhash.a /usr/lib/libmhash.a
ln -s /usr/local/lib/libmhash.la /usr/lib/libmhash.la
ln -s /usr/local/lib/libmhash.so /usr/lib/libmhash.so
ln -s /usr/local/lib/libmhash.so.2 /usr/lib/libmhash.so.2
ln -s /usr/local/lib/libmhash.so.2.0.1 /usr/lib/libmhash.so.2.0.1

ldconfig


Downloadfile lib-web/mcrypt/${mcrypt_dir}.tar.gz
./configure
make
make install


Downloadfile lib-web/zlib/${zlibs_dir}.tar.gz
./configure
make CFLAGS=-fpic
make install


Downloadfile lib-web/freetype/${freetype_dir}.tar.gz
./configure --prefix=/usr/local/${freetype_dir}
make
make install


Downloadfile lib-web/libpng/${libpng_dir}.tar.gz
./configure
make CFLAGS=-fpic
make install


Downloadfile lib-web/libevent/${libevent_dir}.tar.gz
./configure
make
make install


Downloadfile lib-web/memcached/${memcached_dir}.tar.gz
./configure
make
make install


Downloadfile lib-web/pcre/${pcre_dir}.tar.gz
./configure --enable-utf8 --enable-unicode-properties --disable-shared
make
make install
ln -s /usr/local/lib/libpcre.so.1 /lib


Downloadfile lib-web/jpegsrc/jpegsrc.v6b.tar.gz jpeg-6b
if [ -e /usr/share/libtool/config.guess ];then
mv config.guess config.guess.old
cp -f /usr/share/libtool/config.guess .
elif [ -e /usr/share/libtool/config/config.guess ];then
mv config.guess config.guess.old
cp -f /usr/share/libtool/config/config.guess .
fi
if [ -e /usr/share/libtool/config.sub ];then
mv config.sub config.sub.old
cp -f /usr/share/libtool/config.sub .
elif [ -e /usr/share/libtool/config/config.sub ];then
mv config.sub config.sub.old
cp -f /usr/share/libtool/config/config.sub .
fi
./configure --prefix=/usr/local/jpeg.6 --enable-shared --enable-static
mkdir -p /usr/local/jpeg.6/include
mkdir /usr/local/jpeg.6/lib
mkdir /usr/local/jpeg.6/bin
mkdir -p /usr/local/jpeg.6/man/man1
make
make install-lib
make install


Downloadfile lib-web/curl/${curl_dir}.tar.gz
./configure --prefix=/usr/local/curl --disable-ipv6
make
make install
cp -f /usr/local/curl/bin/* /usr/bin/


if [ "$machine" = "x86_64" ] ; then
	ln -s /usr/local/lib/libpcre.so.1 /lib64
	ln -s /usr/lib64/libpng.* /usr/lib/
	ln -s /usr/lib64/libjpeg.* /usr/lib/
fi


Downloadfile lib-web/python/${Python_dir}.tgz
./configure
make
make install


if [ "$CUSTOMER" = "yes" ] ; then
	# Git only for MTimer CMS customers
	Downloadfile lib-web/git/${git_dir}.tar.gz
	autoconf
	./configure
	make
	make install


	Downloadfile lib-web/node/${node_dir}.tar.gz
	sed -i '1s/python/python2.7/1' ./configure  ##########CentOS 5#########
	./configure --prefix=/mtimer/node
	make
	make install


	# For nodechat
	echo 'export PATH=$PATH:/mtimer/node/bin' >> /etc/profile
	source /etc/profile

	# only for MTimer CMS customers
	#npm install express -gd
	#npm install forever -gd
	#npm install forever-webui -g
	#npm install node-gyp -g
	#npm install socket.io -g
	#npm install hiredis redis -g
	#npm install mysql@2.0.0-alpha8 -g



	#Downloadfile lib-web/redis/${redis_dir}.tar.gz
	#make
	#make install
	#cd ${LNMPA_PATH}
	#cp -f redis.conf  /etc/
	#cp redis /etc/init.d/
	#chmod +x /etc/init.d/redis
	#chkconfig --add redis
	#chkconfig redis on
	#service redis start
fi



# For MYSQL / MariaDB high versions
if [ "$SQLTODO" -gt "1" ]; then
	Downloadfile lib-web/cmake/${cmake_dir}.tar.gz
	./bootstrap
	make
	make install


	Downloadfile lib-web/bison/${bison_dir}.tar.gz
	./configure
	make
	make install
fi



# For Apache 2.4.X
if [ "$APACHETODO" == "4" ]; then
	Downloadfile lib-web/apr/${apr_dir}.tar.gz
	sed -i 's/$RM "$cfgfile"/#$RM "$cfgfile"/g' ./configure
	./configure
	make
	make install

	Downloadfile lib-web/apr/${apr_util_dir}.tar.gz
	./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr
	make
	make install

	Downloadfile lib-web/apr/${apr_iconv_dir}.tar.gz
	./configure --prefix=/mtimer/server/httpd --with-apr=/usr/local/apr
	make
	make install
fi


Downloadfile lib-web/re2c/${re2c_dir}.tar.gz
./configure
make
make install


# If you gcc version below 4.2, libmemcached & php ext memcached will not be installed
# You can upgrade gcc >= 4.2 ,but it taks some time so skip it in LNMPA
#Downloadfile lib-web/gcc/gcc-4.9.0.tar.bz2
#./contrib/download_prerequisites
#cd ..
#mkdir gcc-build-4.9.0
#cd  gcc-build-4.9.0
#../gcc-4.9.0/configure --prefix=/usr/local/gcc-4.9.0 --enable-checking=release --enable-languages=c,c++ --disable-multilib
#make -j4
#make install
#cat >> ~/.bashrc <<EOF
#GCCHOME=/usr/local/gcc-4.9.0
#PATH=$GCCHOME/bin:$PATH
#LD_LIBRARY_PATH=$GCCHOME/lib
#export GCCHOME PATH LD_LIBRARY_PATH
#EOF


gccv1=$(gcc -dumpversion | cut -f1 -d'.')
gccv2=$(gcc -dumpversion | cut -f2 -d'.')
if [ "$gccv1" = "4" ] && [ $gccv2 -gt 1 ]; then
	Downloadfile lib-web/libmemcached/${libmemcached_dir}.tar.gz
	./configure
	make
	make install
fi


# sqlit fix
cd ${LNMPA_PATH}
wget -c --tries=3 -O lemon.c http://www.sqlite.org/src/raw/tool/lemon.c?name=680980c7935bfa1edec20c804c9e5ba4b1dd96f5
gcc -o lemon lemon.c
mv lemon /usr/local/bin/

cd ${MINSTALL_PATH}