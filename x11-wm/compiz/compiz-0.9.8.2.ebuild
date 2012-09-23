EAPI=4

inherit base gnome2 cmake-utils eutils python

UURL="http://archive.ubuntu.com/ubuntu/pool/main/c/${PN}"
UVER="0ubuntu1"
URELEASE="quantal"
MY_P="${P/-/_}"
GNOME2_LA_PUNT="1"

DESCRIPTION="Compiz Fusion OpenGL window and compositing manager patched for the Unity desktop"
HOMEPAGE="http://unity.ubuntu.com/"
SRC_URI="${UURL}/${MY_P}+bzr3377.orig.tar.gz
	${UURL}/${MY_P}+bzr3377-${UVER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

COMMONDEPEND="
	!x11-libs/compiz-bcop
	!x11-libs/libcompizconfig
	!x11-plugins/compiz-plugins-main
	>=dev-libs/boost-1.34.0
	dev-libs/glib:2
	dev-cpp/glibmm
	dev-libs/libxml2
	dev-libs/libxslt
	dev-python/pyrex
	gnome-base/gconf
	>=gnome-base/librsvg-2.14.0:2
	media-libs/libpng
	>=x11-libs/cairo-1.0
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
	>=x11-libs/startup-notification-0.7
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

src_prepare() {
	# Apply Ubuntu patchset #
	epatch "${WORKDIR}/${MY_P}+bzr3377-${UVER}.diff"        # This needs to be applied for the debian/ directory to be present #
	for patch in $(cat "${S}/debian/patches/series" | grep -v '#'); do
		PATCHES+=( "${S}/debian/patches/${patch}" )
	done

	# Set compiz Window Decorations to !state=maxvert so top appmenu bar behaviour functions correctly #
	PATCHES+=( "${FILESDIR}/${PN}-0.9.8_decor-setting.diff" )

	base_src_prepare

	# Fix DESTDIR #
	epatch "${FILESDIR}/${P}_base.cmake.diff"
	einfo "Fixing DESTDIR for the following files:"
	for file in $(grep -r 'DESTINATION \$' * | grep -v DESTDIR | awk -F: '{print $1}' | uniq); do
		echo "    "${file}""
		sed -e "s:DESTINATION :DESTINATION \${COMPIZ_DESTDIR}:g" \
			-i "${file}"
	done

	# Fix installation of ccsm and compizconfig-python #
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
		-DUSE_GSETTINGS=OFF
		-DCOMPIZ_DISABLE_GS_SCHEMAS_INSTALL=ON
		-DCOMPIZ_BUILD_TESTING=OFF
		-DCOMPIZ_DESTDIR="${D}"
		-DCOMPIZ_SYSCONFDIR="${D}etc"
		-DCMAKE_MODULE_PATH="${D}usr/share/cmake"
		-DCOMPIZ_DEFAULT_PLUGINS="ccp,core,composite,opengl,compiztoolbox,decor,vpswitch,\
snap,mousepoll,resize,place,move,wall,grid,regex,imgpng,session,gnomecompat,animation,fade,\
unitymtgrabhandles,workarounds,scale,expo,ezoom,unityshell"
		"
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