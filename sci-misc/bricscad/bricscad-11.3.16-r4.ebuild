# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="BricsCad for Linux"
HOMEPAGE="http://www.bricscad.com/"
BINPACK="Bricscad-V11.3.16-4-it_IT.tgz"
SRC_URI="http://www.bricscad.com/download/${BINPACK}"
RESTRICT="fetch strip"

LICENSE="evaluation, comercial"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="virtual/opengl app-emulation/wine"
RDEPEND=""


pkg_nofetch() {
	einfo "You decided emerge bricscad, binary package into your system."
	einfo "At first, plz register, fill form, and fetch ${BINPACK}"
	einfo "from ${HOMEPAGE}"
	einfo "Then move ${BINPACK} to your ${DISTDIR}"
} 

src_install() {
	mkdir -p ${D}/opt/bricscad
	mkdir -p ${D}/bin/
	cp -a ${WORKDIR}/* ${D}/opt/bricscad || die
	chmod +x ${D}/opt/bricscad/bricscad
	chmod +x ${D}/opt/bricscad/bricscad.sh
	einfo "Now some test on binaries. It takes long time be patient."
}

pkg_postinst() {
	einfo "Start Bricscad with:"
	einfo "cd /opt/bricscad"
	einfo "sh bricscad.sh"
	einfo "Every 30 days remove this file: rm /home/vasco/.bricsys/.license"
}
