# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

#DESCRIPTION="Large Scala Data Center Cluster Manager"
DESCRIPTION="Cluster manager for sharing distributed application frameworks"
HOMEPAGE="http://mesos.apache.org/"
SRC_URI="mirror://apache/mesos/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="amd64"
IUSE="+java +python"
SLOT="0"

DEPEND="net-misc/curl
	dev-libs/cyrus-sasl
	python? ( dev-lang/python dev-python/boto )
	java? ( virtual/jdk dev-java/maven-bin )"

ECONF_SOURCE="${S}"

#inherit java-pkg-opt-2

src_prepare() {
	mkdir "${S}/build" || die
}

src_configure() {
	cd "${S}/build"
	econf \
		$(use_enable python) \
		$(use_enable java)
}

src_compile() {
	cd "${S}/build"
	emake # V=1
}

src_install() {
	cd "${S}/build"
	emake DESTDIR="${D}" install || die "emake install failed"
}

# vim:noet:ts=4:sw=4
