# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

inherit cmake-utils bzr

EBZR_REPO_URI="lp:cairo-dock-core"
# You can specify a certain revision from the repository here.
# Or comment it out to choose the latest ("live") revision.
# EBZR_REVISION="959"
# EBZR_REPO_URI="lp:cairo-dock-core/3.1"

DESCRIPTION="Cairo-dock is a fast, responsive, Mac OS X-like dock."
HOMEPAGE="https://launchpad.net/cairo-dock-core/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="xcomposite"

# Dependencies are listed here:
# http://glx-dock.org/ww_page.php?p=From%20BZR&lang=en

# pangox-compat is deprecated so check it sometimes if required anymore

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	dev-libs/libxml2
	gnome-base/gvfs
	gnome-base/librsvg
	net-misc/curl
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/gtk+
	x11-libs/gtkglext
	x11-libs/libXrender
	x11-libs/pango
	x11-libs/pangox-compat
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

src_configure() {
	mycmakeargs="${mycmakeargs} -DROOT_PREFIX=${D} -DCMAKE_INSTALL_PREFIX=/usr -DLIB_SUFFIX="
	cmake-utils_src_configure
}

pkg_postinst() {
	ewarn ""
	ewarn ""
	ewarn "You have installed from a LIVE EBUILD, NOT AN OFFICIAL RELEASE."
	ewarn "   Thus, it may FAIL to run properly."
	ewarn ""
	ewarn "This ebuild is not supported by a Gentoo developer."
	ewarn "   So, please do NOT report bugs to Gentoo's bugzilla."
	ewarn "   Instead, report all bugs to yellowhat46@gmail.com"
	ewarn ""
	ewarn ""
}
