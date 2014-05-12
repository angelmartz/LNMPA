#! /bin/sh
# Load functions
. ${LNMPA_PATH}/functions
Downloadfile ${SQLTYPE}/${sql_dir}.tar.gz


case "$SQLTODO" in
	1) # MYSQL 5.1.X && MariaDB 5.3.X
		./configure \
		--prefix=/mtimer/server/${SQLTYPE} \
		--localstatedir=/mtimer/server/${SQLTYPE}/data \
		--with-unix-socket-path=/tmp/mysql.sock \
		--sysconfdir=/etc \
		--with-mysqld-user=mysql \
		--with-charset=utf8 \
		--with-collation=utf8_general_ci \
		--with-extra-charsets=all \
		--enable-thread-safe-client \
		--with-big-tables \
		--with-ssl \
		--with-embedded-server \
		--enable-local-infile \
		--enable-assembler \
		--with-plugins=innobase,partition \
		--with-mysqld-ldflags=-all-static \
		--with-client-ldflags=-all-static \
		--without-debug
		# --with-plugins=max-no-ndb
		;;
	2|3|5|6) # MYSQL 5.5.X, 5.6.X && MariaDB 5.5.X, 10.0.X
		cmake . \
		-DCMAKE_INSTALL_PREFIX=/mtimer/server/${SQLTYPE} \
		-DMYSQL_DATADIR=/mtimer/server/${SQLTYPE}/data \
		-DMYSQL_UNIX_ADDR=/tmp/mysql.sock \
		-DSYSCONFDIR=/etc \
		-DWITH_EMBEDDED_SERVER=1 \
		-DCMAKE_BUILD_TYPE=Release \
		-DDEFAULT_CHARSET=utf8 \
		-DDEFAULT_COLLATION=utf8_general_ci \
		#-DWITH_MYISAM_STORAGE_ENGINE=1 \
		-DWITH_INNOBASE_STORAGE_ENGINE=1 \
		#-DWITH_MEMORY_STORAGE_ENGINE=1 \
		-DWITH_PARTITION_STORAGE_ENGINE=1 \
		-DWITH_SSL=system \
		-DWITH_READLINE=1 \
		-DENABLED_LOCAL_INFILE=1 \
		#-DMYSQL_USER=mysql \
		-DMYSQL_TCP_PORT=3306 \
		-DWITH_DEBUG=0
		;;
esac


make
make install

mv -f /etc/my.cnf /etc/my.cnf.old
if [ "$SQLTODO" = "1" ];then
	cp -f ${MCONF_PATH}/${SQLTYPE}/my-old.cnf /etc/my.cnf
else
	cp -f ${MCONF_PATH}/${SQLTYPE}/my-new.cnf /etc/my.cnf
fi
chown -R mysql /mtimer/server/${SQLTYPE}/
chmod 755 ${MUNPACKED_PATH}/${sql_dir}/scripts/mysql_install_db
${MUNPACKED_PATH}/${sql_dir}/scripts/mysql_install_db --basedir=/mtimer/server/${SQLTYPE} --datadir=/mtimer/server/${SQLTYPE}/data --user=mysql --defaults-file=/etc/my.cnf
chown -R root:root /mtimer/server/${SQLTYPE}/
chgrp -R mysql /mtimer/server/${SQLTYPE}/.
chown -R mysql:mysql /mtimer/server/${SQLTYPE}/data/
chown -R mysql:mysql /mtimer/log/${SQLTYPE}


cd ${LNMPA_PATH}
cp -f ${MINIT_PATH}/${SQLTYPE} /etc/init.d/mysql
chmod 755 /etc/init.d/mysql


if [ "$SQLTYPE" = "mysql" ];then
	cat >> /etc/ld.so.conf.d/mysql.conf<<-EOF
	/mtimer/server/mysql/lib/mysql
	/usr/local/lib
	EOF
	ln -vs /mtimer/server/mysql/lib/mysql /usr/lib/mysql
else 
	cat >> /etc/ld.so.conf.d/mariadb.conf<<-EOF
	/mtimer/server/mariadb/lib
	/usr/local/lib
	EOF
	ln -vs /mtimer/server/mariadb/lib /usr/lib/mysql
fi

ldconfig

ln -vs /mtimer/server/${SQLTYPE}/include/mysql /usr/include/mysql
#for i in /mtimer/server/${SQLTYPE}/bin/*; do ln -s $i /usr/bin/$2; done
ln -s /mtimer/server/${SQLTYPE}/bin/mysql /usr/bin/mysql
ln -s /mtimer/server/${SQLTYPE}/bin/mysqldump /usr/bin/mysqldump
ln -s /mtimer/server/${SQLTYPE}/bin/myisamchk /usr/bin/myisamchk
ln -s /mtimer/server/${SQLTYPE}/bin/mysqladmin /usr/bin/mysqladmin

chkconfig --level 2345 mysql on
#ln -s /etc/init.d/mysql /etc/rc3.d/S99mysql
#ln -s /etc/init.d/mysql /etc/rc0.d/K01mysql

service mysql start

cd ${MINSTALL_PATH}