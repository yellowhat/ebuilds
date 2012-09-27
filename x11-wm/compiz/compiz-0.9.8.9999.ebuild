# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit versionator

MINOR_VERSION=$(get_version_component_range 4)
MAJOR_BRANCH=$(get_version_component_range 1-3)

if [[ ${MINOR_VERSION} == 9999 ]]; then
	EBZR_REPO_URI="lp:compiz"
	inherit bzr
	SRC_URI=""
else
	SRC_URI="http://launchpad.net/${PN}/${MAJOR_BRANCH}/${PV}/+download/${P}.tar.bz2"
fi

inherit eutils cmake-utils gnome2-utils toolchain-funcs python

DESCRIPTION="Compiz OpenGL window and compositing manager"
HOMEPAGE="https://launchpad.net/compiz"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

COMMONDEPEND="
	gnome-extra/nm-applet
	x11-apps/setxkbmap

	dev-libs/boost
	dev-libs/glib:2
	dev-cpp/glibmm
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/protobuf
	dev-python/pyrex
	gnome-base/gconf
	gnome-base/librsvg
	media-libs/libpng
	x11-libs/cairo
	x11-libs/libnotify
	x11-libs/pango
	x11-libs/libwnck:1
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXinerama
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/startup-notification
	virtual/glu
	virtual/opengl"

DEPEND="${COMMONDEPEND}
	dev-util/pkgconfig
	x11-proto/damageproto
	x11-proto/xineramaproto"

RDEPEND="${COMMONDEPEND}
	x11-apps/mesa-progs
	x11-apps/xvinfo"

pkg_setup() {
	python_set_active_version 2
}

src_unpack() {
	if [[ ${MINOR_VERSION} == 9999 ]]; then
		bzr_src_unpack
	else
		default
	fi
}

src_prepare() {

	## Set compiz Window Decorations to !state=maxvert so top appmenu bar behaviour functions correctly #
	PATCHES+=( "${FILESDIR}/${PN}-0.9.8_decor-setting.diff" )

	base_src_prepare

	## Fix DESTDIR #
	epatch "${FILESDIR}/${PN}-0.9.8.0_base.cmake.diff"
	einfo "Fixing DESTDIR for the following files:"
	for file in $(grep -r 'DESTINATION \$' * | grep -v DESTDIR | awk -F: '{print $1}' | uniq); do
		echo "    "${file}""
		sed -e "s:DESTINATION :DESTINATION \${COMPIZ_DESTDIR}:g" \
			-i "${file}"
	done

	## Fix installation of ccsm and compizconfig-python
	sed -e "/message/d" \
		-i compizconfig/cmake/exec_setup_py_with_destdir.cmake || die
	sed -e "s:\${INSTALL_ROOT_ARGS}:--root=${D}:g" \
		-i compizconfig/cmake/exec_setup_py_with_destdir.cmake || die
}

src_configure() {

	mycmakeargs="${mycmakeargs}
		-DCOMPIZ_BIN_PATH="/usr/bin"
		-DCOMPIZ_BUILD_WITH_RPATH=FALSE
		-DCOMPIZ_DISABLE_SCHEMAS_INSTALL=ON
		-DCOMPIZ_INSTALL_GCONF_SCHEMA_DIR="${D}etc/gconf/schemas"
		-DCOMPIZ_PACKAGING_ENABLED=ON
		-DCOMPIZ_DISABLE_PLUGIN_KDE=ON
		-DUSE_KDE4=OFF
		-DUSE_GNOME=OFF
		-DUSE_GTK=ON
		-DUSE_GSETTINGS=ON
		-DCOMPIZ_DISABLE_GS_SCHEMAS_INSTALL=OFF
		-DCOMPIZ_BUILD_TESTING=OFF
		-DCOMPIZ_DESTDIR="${D}"
		-DCOMPIZ_SYSCONFDIR="${D}etc"
		-DCMAKE_MODULE_PATH="${D}usr/share/cmake"
		-DCOMPIZ_DEFAULT_PLUGINS="ccp"
		"
	cmake-utils_src_configure
}

src_install() {
	pushd ${CMAKE_BUILD_DIR}
		emake findcompiz_install
		emake findcompizconfig_install
		emake install

		# Window manager desktop file for GNOME #
#		insinto /usr/share/gnome/wm-properties/
#		doins gtk/gnome/compiz.desktop

		# Keybinding files #
#		insinto /usr/share/gnome-control-center/keybindings
#		doins -r gtk/gnome/*.xml

	popd ${CMAKE_BUILD_DIR}

	pushd ${CMAKE_USE_DIR}

		# Docs #
#		dodoc AUTHORS NEWS README
#		doman debian/{ccsm,compiz,gtk-window-decorator}.1

		# X11 startup script #
#		insinto /etc/X11/xinit/xinitrc.d/
#		doins debian/65compiz_profile-on-session

		# Unity Compiz profile configuration file #
#		insinto /etc/compizconfig
#		doins debian/unity.ini

		# Compiz profile upgrade helper files for ensuring smooth upgrades from older configuration files #
#		insinto /etc/compizconfig/upgrades/
#		doins debian/profile_upgrades/*.upgrade
#		insinto /usr/lib/compiz/migration/
#		doins postinst/convert-files/*.convert

		# Default GConf settings #
#		insinto /usr/share/gconf/defaults
#		newins debian/compiz-gnome.gconf-defaults 10_compiz-gnome

		# Default GSettings settings #
#		insinto /usr/share/glib-2.0/schemas
#		newins debian/compiz-gnome.gsettings-override 10_compiz-ubuntu.gschema.override

		# Script for resetting all of Compiz's settings #
		insinto /usr/bin
		doins "${FILESDIR}/compiz.reset"

		# Script for migrating GConf settings to GSettings #
#		insinto /usr/lib/compiz/
#		doins postinst/migration-scripts/02_migrate_to_gsettings.py
#		insinto /etc/xdg/autostart/
#		doins "${FILESDIR}/compiz-migrate-to-dconf.desktop"

	popd ${CMAKE_USE_DIR}
}
