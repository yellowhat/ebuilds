# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit eutils

DESCRIPTION="Emerald Window Decorator"
HOMEPAGE="http://www.compiz.org/"
SRC_URI="http://cgit.compiz.org/fusion/decorators/${PN}/snapshot/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	x11-libs/gtk+:2
	>=x11-libs/libwnck-2.14.2:1
	>=x11-wm/compiz-0.9.0"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	>=dev-util/pkgconfig-0.19
	>=sys-devel/gettext-0.15"

src_configure() {
	./autogen.sh
	econf \
		--disable-dependency-tracking \
		--disable-static \
		--enable-fast-install \
		--disable-mime-update
}

src_install() {
	emake DESTDIR="${D}" install
	find "${D}" -name '*.la' -delete
}
