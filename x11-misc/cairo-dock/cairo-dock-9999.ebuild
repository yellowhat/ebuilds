# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

inherit cmake-utils bzr

EBZR_REPO_URI="lp:cairo-dock-core"
#EBZR_REPO_URI="lp:cairo-dock-core/3.1"

DESCRIPTION="Cairo-dock is a fast, responsive, Mac OS X-like dock."
HOMEPAGE="https://launchpad.net/cairo-dock-core/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="xcomposite"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libxml2
	gnome-base/librsvg
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gtk+
	x11-libs/gtkglext
	x11-libs/libXrender
	xcomposite? (
		x11-libs/libXcomposite
		x11-libs/libXinerama
		x11-libs/libXtst
	)
"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig
	sys-devel/gettext
"

src_prepare() {

	bzr_src_prepare

}

MAKE_IN_SOURCE_BUILD=true

pkg_postinst() {

	ewarn "THIS IS A LIVE EBUILD, SO YOU KNOW THE RISKS !"
	ewarn "DO NOT report bugs to Gentoo's bugzilla"

}
