# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

EBZR_REPO_URI="lp:compiz"

inherit base bzr gnome2 cmake-utils eutils python

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
	virtual/glu"

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
	bzr_src_unpack
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
		-DCOMPIZ_DISABLE_PLUGIN_KDECOMPAT=ON
		-DUSE_KDE4=OFF
		-DUSE_GNOME=OFF
		-DUSE_GTK=ON
		-DUSE_GSETTINGS=OFF
		-DCOMPIZ_DISABLE_GS_SCHEMAS_INSTALL=ON
		-DCOMPIZ_BUILD_TESTING=OFF
		-DCOMPIZ_DESTDIR="${D}"
		-DCOMPIZ_SYSCONFDIR="${D}etc"
		-DCMAKE_MODULE_PATH="${D}usr/share/cmake"
		-DCOMPIZ_DEFAULT_PLUGINS="addhelper,animation,animationaddon,annotate,\
		bench,ccp,clone,commands,compiztoolbox,composite,copytex,crashhandler,cube,\
		cubeaddon,dbus,decor,expo,extrawm,ezoom,fade,fadedesktop,firepaint,gnomecompat,\
		grid,group,imgjpeg,imgpng,imgsvg,inotify,loginout,mag,maximumize,mblur,mousepoll,\
		move,neg,notification,obs,opacify,opengl,place,put,reflex,regex,resize,resizeinfo,ring,\
		rotate,scale,scaleaddon,scalefilter,screenshot,session,shelf,shift,showdesktop,\
		showmouse,showrepaint,snap,splash,stackswitch,staticswitcher,switcher,td,text,\
		thumbnail,titleinfo,trailfocus,trip,vpswitch,wall,wallpaper,water,widget,winrules,wobbly,\
		workarounds,workspacenames""

	cmake-utils_src_configure
}

src_install() {

	pushd ${CMAKE_BUILD_DIR}
	emake findcompiz_install
	emake findcompizconfig_install
	emake install
	popd ${CMAKE_BUILD_DIR}

#	insinto /etc/compizconfig
#	doins "${WORKDIR}/debian/unity.ini"

#	exeinto /usr/bin
#	doexe "${WORKDIR}/debian/compiz-decorator"

#	exeinto /usr/bin
#	doexe "${FILESDIR}/update-gconf-defaults"

#	insinto /usr/share/compiz
#	doins -r "${FILESDIR}/gconf-defaults"
}