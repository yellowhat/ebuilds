# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="Virtual package for MSC Marc"
HOMEPAGE="http://www.mscsoftware.com/"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	|| (
		app-shells/ksh
		sys-libs/libstdc++-v3
	)"
DEPEND=""

pkg_postinst() {
	       einfo "Now you can install MSC Marc Mentat ${PV}"
}