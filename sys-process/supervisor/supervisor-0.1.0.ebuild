# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Process Supervsior"
HOMEPAGE="https://github.com/xzero/supervisor"
SRC_URI="https://github.com/xzero/supervisor/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="amd64"
IUSE="+suid"
SLOT="0"

DEPEND="dev-util/cmake"
ECONF_SOURCE="${S}"

src_configure() {
	cmake . \
		-DCMAKE_BUILD_TYPE="release" \
		-DCMAKE_INSTALL_PREFIX="/usr"
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	use suid && fperms 4755 /usr/sbin/${PN}
	dodoc README.md
}

# vim:noet:ts=4:sw=4
