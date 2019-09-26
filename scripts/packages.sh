#! /usr/bin/env bash

e() {
  echo -e "  \e[1;32m[install] ==> $@\e[0m";
}

e "Remove known-bad or known-conflicting packages."
yum -y remove \
    check-mk-agent* \
    check_mk-agent* \
    mariadb-libs* \
    mysql-5.1* \
    mysql-libs-5.1* \
    mysql-server-5.1* \
    php-5.3* \
    php-cli-5.3* \
    php-common-5.3* \
    php-gd-5.3* \
    php-mbstring-5.3* \
    php-mysql-5.3* \
    php-pdo-5.3* \
    php-pdo-5.3* \
    php-snmp-5.3* \
;

e "Add /usr/local/bin to the \$PATH."
echo "export PATH=\$PATH:/usr/local/bin" >> /etc/bashrc

major_version="`sed 's/^.\+ release \([.0-9]\+\).*/\1/' /etc/redhat-release | awk -F. '{print $1}'`";

if [ "$major_version" -ge 6 ] && [ "$major_version" -le 7 ]; then
   e "Add a set of known/trusted repos."
   curl -s -o /etc/yum.repos.d/centos7.repo https://raw.githubusercontent.com/skyzyx/centos7-repos/master/centos7.repo
fi


e "Sync the correct packages for the distro."
yum -y distro-sync

#e "Remove any errant CentOS repo files."
#rm -f /etc/yum.repos.d/CentOS-*

e "Clean the Yum cache"
yum clean all

e "Install new packages"
yum -y groupinstall "Development Tools"


if [ "$major_version" -ge 6 ] && [ "$major_version" -le 7 ]; then
   yum install -y centos7-repos
fi

yum -y install \
    bash \
    bash-completion \
    bind-utils \
    bzip2 \
    ca-certificates \
    cpp \
    cronie \
    cronie-anacron \
    crontabs \
    curl \
    deltarpm \
    gawk \
    gcc  \
    gcc-c++  \
    glib2 \
    glibc \
    htop \
    iftop \
    iptables \
    iputils \
    kernel-devel-`uname -r`  \
    kernel-headers-`uname -r` \
    libcgroup \
    libselinux-python \
    make \
    nano \
    nc \
    net-tools \
    nscd \
    ntp \
    ntpdate \
    openssh \
    openssh-clients \
    openssh-server \
    openssl \
    pcre \
    perl \
    psmisc \
    readline \
    rpm \
    screen \
    sed \
    setuptool \
    strace \
    sysstat \
    tcpdump \
    tcp_wrappers \
    telnet \
    traceroute \
    tree \
    tzdata \
    uuid \
    vim-enhanced \
    wget \
    xz \
    yum \
    yum-cron \
    yum-plugin-aliases \
    yum-plugin-changelog \
    yum-plugin-fastestmirror \
    yum-plugin-list-data \
    yum-plugin-ps \
    yum-plugin-show-leaves \
    yum-plugin-upgrade-helper \
    yum-plugin-versionlock \
    yum-utils \
    zip \
	zsh \
    zlib \
;

e "Update existing packages"
yum -y update;
