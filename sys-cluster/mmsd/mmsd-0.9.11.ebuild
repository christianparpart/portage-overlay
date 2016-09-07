# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Mesos Marathon Service Discovery"
HOMEPAGE="https://github.com/dawanda/mmsd"
SRC_URI="https://github.com/dawanda/mmsd/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 amd64"
IUSE=""

DEPEND=">=dev-lang/go-1.6"
RDEPEND="${DEPEND}
	sys-process/supervisor"

GOPATH="${WORKDIR}/${P}"
S="${GOPATH}/src/github.com/dawanda"

src_unpack() {
	mkdir -p "${S}"
	cd ${S}
	unpack ${A}
	mv ${P} ${PN}
}

src_compile() {
	cd ${S}/${PN}
	export GOPATH
	export PATH="${GOPATH}/bin:${PATH}"
	sed -i -e 's/\(const appVersion = \)".*"$/\1"'${PV}'"/' main.go
	go get github.com/tools/godep || die "godep"
	godep restore
	godep go build
}

src_install() {
	cd ${S}/${PN}
	dobin mmsd
	newinitd ${FILESDIR}/mmsd.initd mmsd
	newconfd ${FILESDIR}/mmsd.confd mmsd
}
