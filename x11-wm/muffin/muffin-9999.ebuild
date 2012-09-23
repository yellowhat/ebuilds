# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit autotools eutils git-2 gnome2

DESCRIPTION="Compositing window manager forked from Mutter for use with Cinnamon"
HOMEPAGE="http://cinnamon.linuxmint.com/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/linuxmint/muffin.git"

LICENSE="GPL-2"
SLOT="0"
IUSE="+introspection test xinerama"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND=">=x11-libs/pango-1.2[X,introspection?]
	>=x11-libs/cairo-1.10[X]
	x11-libs/gdk-pixbuf:2[introspection?]
	>=x11-libs/gtk+-3.3.3:3[introspection?]
	>=gnome-base/gconf-2:2
	gnome-base/gsettings-desktop-schemas
	>=dev-libs/glib-2.14:2
	>=media-libs/clutter-1.7.5:1.0[introspection?]
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/startup-notification-0.7
	>=x11-libs/libXcomposite-0.2

	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXrender

	gnome-extra/zenity

	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="${COMMON_DEPEND}
	>=app-text/gnome-doc-utils-0.8
	sys-devel/gettext
	virtual/pkgconfig
	>=dev-util/intltool-0.35
	test? ( app-text/docbook-xml-dtd:4.5 )
	xinerama? ( x11-proto/xineramaproto )
	x11-proto/xextproto
	x11-proto/xproto"
RDEPEND="${COMMON_DEPEND}
	!x11-misc/expocity"

src_unpack() {
	if [[ ${PV} == "9999" ]] ; then
		git-2_src_unpack
		cd "${S}"
#		rm -f configure
	else
		unpack ${A}
		cd "${S}"
	fi

	# need to run autoreconf, https://github.com/linuxmint/muffin/issues/16
	eautoreconf
}

pkg_setup() {
	DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS README* *.txt doc/*.txt"
	G2CONF="${G2CONF}
		--disable-static
		--enable-gconf
		--enable-shape
		--enable-sm
		--enable-startup-notification
		--enable-xsync
		--enable-verbose-mode
		--enable-compile-warnings=maximum
		--with-libcanberra
		$(use_enable introspection)
		$(use_enable xinerama)"
}
