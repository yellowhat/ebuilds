# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

EBZR_REPO_URI="lp:cairo-dock-plug-ins"
#EBZR_BRANCH="${PV%.*}"
#EBZR_REPO_URI="lp:cairo-dock-plug-ins/3.1"
#EBZR_REVISION="1939"

inherit cmake-utils bzr

DESCRIPTION="Official plugins for cairo-dock"
HOMEPAGE="https://launchpad.net/cairo-dock-plug-ins/"
SRC_URI=""

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="alsa exif gmenu terminal vala webkit xfce xgamma xklavier"

RDEPEND="
	x11-misc/cairo-dock
	x11-libs/cairo
	gnome-base/librsvg
	dev-libs/libxml2
	alsa? ( media-libs/alsa-lib )
	exif? ( media-libs/libexif )
	gmenu? ( gnome-base/gnome-menus )
	terminal? ( x11-libs/vte )
	webkit? ( >=net-libs/webkit-gtk-1.0 )
	xfce? ( xfce-base/thunar )
	xgamma? ( x11-libs/libXxf86vm )
	xklavier? ( x11-libs/libxklavier )
	vala? ( dev-lang/vala:0.12 )
"

DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	dev-util/pkgconfig
	dev-libs/libdbusmenu:3[gtk]
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
