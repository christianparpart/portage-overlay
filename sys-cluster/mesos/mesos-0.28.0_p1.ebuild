# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils flag-o-matic multilib

DESCRIPTION="Large Scale Data Center Cluster Resource Manager"
HOMEPAGE="http://mesos.apache.org/"

SRC_URI="http://apache.org/dist/${PN}/${PV}/${P%_*}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"
IUSE="ssl java python"
SLOT="0"

DEPEND="net-misc/curl
        dev-libs/cyrus-sasl
        python? ( dev-lang/python dev-python/boto )
        java? ( virtual/jdk )
		>=dev-libs/libnl-3.2.27:3
        dev-java/maven-bin
        dev-libs/hyperleveldb
        dev-python/pip
        dev-python/wheel
        dev-vcs/subversion"

RDEPEND="python? ( dev-lang/python )
         >=virtual/jdk-1.6
         ${DEPEND}"

S="${WORKDIR}/${PN}-${PV%_*}"
ECONF_SOURCE="${S}"

src_prepare() {
    mkdir "${S}/build" || die
}

src_configure() {
  cd "${S}/build"
  econf $(use_enable python) \
        $(use_enable java) \
		$(use_enable ssl) \
		$(use_enable ssl libevent) \
		--with-network-isolator
}

src_compile() {
  cd "${S}/build"
  emake V=1 #-j1
}

src_install() {
  cd "${S}/build"
  emake DESTDIR="${D}" install || die "emake install failed"

  keepdir /var/lib/mesos
  keepdir /var/log/mesos
  keepdir /var/run/mesos

  keepdir /etc/mesos
  keepdir /etc/mesos-slave
  keepdir /etc/mesos-master
  newinitd ${FILESDIR}/mesos-master.initd mesos-master
  newinitd ${FILESDIR}/mesos-slave.initd mesos-slave

  #dosbin ${FILESDIR}/mesos-init-wrapper
  cp ${FILESDIR}/mesos-init-wrapper ${D}/usr/sbin/
}
