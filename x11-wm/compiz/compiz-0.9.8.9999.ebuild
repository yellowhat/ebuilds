# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit versionator

MINOR_VERSION=$(get_version_component_range 4)
MAJOR_BRANCH=$(get_version_component_range 1-3)

if [[ ${MINOR_VERSION} == 9999 ]]; then
	EBZR_REPO_URI="lp:compiz/${MAJOR_BRANCH}"
	inherit bzr
	SRC_URI=""
else
	SRC_URI="http://launchpad.net/${PN}/${MAJOR_BRANCH}/${PV}/+download/${P}.tar.bz2"
fi

inherit base cmake-utils eutils gnome2-utils toolchain-funcs python

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
	<media-libs/glew-1.8
	gnome-base/librsvg
	media-libs/libpng
	media-libs/mesa[gallium,llvm,xorg]
	x11-libs/cairo[X]
	x11-libs/gtk+
	x11-libs/pango
	x11-libs/libnotify
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
	dev-python/pygtk
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

	base_src_prepare

	## Fix DESTDIR #
#	epatch "${FILESDIR}/${PN}-0.9.8.0_base.cmake.diff"
#	einfo "Fixing DESTDIR for the following files:"
#	for file in $(grep -r 'DESTINATION \$' * | grep -v DESTDIR | awk -F: '{print $1}' | uniq); do
#		echo "    "${file}""
#		sed -e "s:DESTINATION :DESTINATION \${COMPIZ_DESTDIR}:g" \
#			-i "${file}"
#	done

	## Fix installation of ccsm and compizconfig-python
#	sed -e "/message/d" \
#		-i compizconfig/cmake/exec_setup_py_with_destdir.cmake || die
#	sed -e "s:\${INSTALL_ROOT_ARGS}:--root=${D}:g" \
#		-i compizconfig/cmake/exec_setup_py_with_destdir.cmake || die
}

src_configure() {

	mycmakeargs="${mycmakeargs}
		-DCMAKE_INSTALL_PREFIX="/usr"
		-DCOMPIZ_INSTALL_GCONF_SCHEMA_DIR="/etc/gconf/schemas"
		-DCOMPIZ_BIN_PATH="/usr/bin"
		-DCOMPIZ_BUILD_WITH_RPATH=FALSE
		-DCOMPIZ_DISABLE_SCHEMAS_INSTALL=ON
		-DCOMPIZ_PACKAGING_ENABLED=TRUE
		-DCOMPIZ_DISABLE_PLUGIN_KDE=ON
		-DUSE_KDE4=OFF
		-DUSE_GNOME=OFF
		-DUSE_GTK=ON
		-DUSE_GCONF=OFF
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
		addpredict /root/.gconf/
		addpredict /usr/share/glib-2.0/schemas/
		GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL=1 emake DESTDIR="${D}" install
	
	popd ${CMAKE_BUILD_DIR}

	pushd ${CMAKE_USE_DIR}
		CMAKE_DIR=$(cmake --system-information | grep '^CMAKE_ROOT' | awk -F\" '{print $2}')
		insinto "${CMAKE_DIR}/Modules/"
		doins cmake/FindCompiz.cmake
		doins compizconfig/libcompizconfig/cmake/FindCompizConfig.cmake

		# Script for resetting all of Compiz's settings #
		insinto /usr/bin
		doins "${FILESDIR}/compiz.reset"

	popd ${CMAKE_USE_DIR}
	
	gnome2_gconf_install
}
