FROM centos:7
WORKDIR /var/www
#Install remi-repo followed by PHP74, and corresponding php modules necessary for mediawiki installation.
RUN yum install epel-release yum-utils -y \
    && yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y \
    && yum-config-manager --enable remi-php74 \
    && yum install wget gettext php php-common php-opcache php-mcrypt php-cli php-gd php-curl \        
    php-mysql php-mbstring php-intl php-xml -y  \
    #Get the mediawiki tar file.
    && wget https://releases.wikimedia.org/mediawiki/1.36/mediawiki-1.36.2.tar.gz \
    --no-check-certificate
#Replacing the Directory root "/var/www/html" of apache configuration to "/var/www/mediawiki"
RUN tar -zxf mediawiki-1.36.2.tar.gz \
    && ln -s mediawiki-1.36.2/ mediawiki \
    &&  sed -i "s,/var/www/html,/var/www/mediawiki,g" /etc/httpd/conf/httpd.conf \
    && rm mediawiki-1.36.2.tar.gz

ENTRYPOINT ["/usr/sbin/httpd"]

CMD ["-D", "FOREGROUND"]

