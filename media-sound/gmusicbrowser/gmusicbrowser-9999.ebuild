# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: bar-overlay/media-sound/gmusicbrowser/gmusicbrowser-9999.ebuild,v 1.3 2012/08/02 16:33:00 -tclover Exp $

EAPI=4

inherit fdo-mime git-2

DESCRIPTION="An open-source jukebox for large collections of mp3/ogg/flac files"
HOMEPAGE="http://squentin.free.fr/gmusicbrowser/gmusicbrowser.html"
EGIT_REPO_URI="git://github.com/squentin/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+a52 aac +alsa +cdio cdparanoia +dbus doc +dts faac +faad +flac +gstreamer jack
lame mac mad modplug +mp3 mpc mplayer musepack +nls notify +ogg oss oss4 pulseaudio
titlebar trayicon twolame vorbis wavpack webkit"

LANGS="cs de es fr hu it ko nl pl pt pt_BR ru sv zh_CN"
for l in ${LANGS}; do
	IUSE+=" linguas_${l}"
done

DEPEND=">=dev-lang/perl-5.8
	dev-vcs/git
	nls? ( sys-devel/gettext )"

DEPEND_GST="dev-perl/GStreamer
	dev-perl/GStreamer-Interfaces
	media-libs/gst-plugins-base
	alsa? ( media-plugins/gst-plugins-alsa )
	jack? ( media-plugins/gst-plugins-jack )
	oss? ( media-plugins/gst-plugins-oss )
	oss4? ( media-plugins/gst-plugins-oss4 )
	pulseaudio? ( media-plugins/gst-plugins-pulse )
	a52? ( media-plugins/gst-plugins-a52dec )
	mac? ( media-libs/gst-plugins-good )
	cdio? ( media-plugins/gst-plugins-cdio )
	cdparanoia? ( media-plugins/gst-plugins-cdparanoia )
	dts? ( media-plugins/gst-plugins-dts )
	faac? ( media-plugins/gst-plugins-faac )
	faad? ( media-plugins/gst-plugins-faad )
	flac? ( media-plugins/gst-plugins-flac media-libs/gst-plugins-good )
	lame? ( media-plugins/gst-plugins-lame )
	mad? ( media-plugins/gst-plugins-mad )
	modplug? ( media-plugins/gst-plugins-modplug )
	mpc? ( media-libs/gst-plugins-bad )
	mp3? ( media-libs/gst-plugins-ugly )
	musepack? ( media-plugins/gst-plugins-musepack )
	ogg? ( media-plugins/gst-plugins-ogg )
	vorbis? ( media-plugins/gst-plugins-vorbis )
	wavpack? ( media-plugins/gst-plugins-wavpack )"

DEPEND_MPLAYER="|| (
	   media-video/mplayer[a52?,alsa?,cdio?,dts?,faac?,faad?,jack?,mad?,oss?,pulseaudio?,twolame?,vorbis?]
	   media-video/mplayer2[a52?,alsa?,cdio?,dts?,faad?,jack?,mad?,oss?,pulseaudio?,vorbis?] )"

DEPEND_OTHER="mp3? ( || ( media-sound/mpg321[alsa?] media-sound/mpg123[alsa?,jack?,oss?,pulseaudio?] ) )
	ogg? ( media-sound/vorbis-tools[flac?,nls?,ogg123] )
	flac? ( media-sound/flac123 )
	vorbis? ( media-sound/vorbis-tools[flac?,nls?,ogg123] )"

RDEPEND="dev-perl/gtk2-perl
	dbus? ( dev-perl/Net-DBus )
	notify? ( dev-perl/Gtk2-Notify )
	titlebar? ( dev-perl/gnome2-wnck )
	trayicon? ( dev-perl/gtk2-trayicon )
	|| (
		gstreamer? ( ${DEPEND_GST} )
		mplayer? ( ${DEPEND_MPLAYER} )
		( ${DEPEND_OTHER} )
	)
	webkit? ( dev-perl/perl-WebKit-GTk )"

src_prepare() {
	sed -e '/menudir/d' -e '/^LINGUAS.*$/d' -i Makefile || die
}

src_install() {
	local l LINGUAS
	for l in ${LANGS}; do
		if use linguas_${l}; then
			LINGUAS+=" ${l}"
		fi
	done
	use nls || LINGUAS=""

	emake \
		DOCS="AUTHORS NEWS README" \
		DESTDIR="${D}" \
		LINGUAS="${linguas}" \
		iconsdir="${D}/usr/share/pixmaps" \
		install

	use doc && dohtml layout_doc.html
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
