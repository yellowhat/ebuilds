# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Compiz Fusion (meta)"
HOMEPAGE="http://www.compiz.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="
	x11-apps/setxkbmap
	gnome-extra/nm-applet

	compiz-wm/compiz
	compiz-wm/ccsm
	compiz-wm/compiz-plugins-main
	x11-wm/emerald"
