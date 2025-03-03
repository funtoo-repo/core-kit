# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

SRC_URI="https://www.nano-editor.org/dist/latest/nano-8.3.tar.gz -> nano-8.3.tar.gz"
KEYWORDS="*"


DESCRIPTION="GNU GPL'd Pico clone with more functionality"
HOMEPAGE="https://www.nano-editor.org/"

LICENSE="GPL-3"
SLOT="0"
IUSE="debug justify +magic minimal ncurses nls +spell static unicode"

LIB_DEPEND="sys-libs/ncurses:0=
	sys-libs/ncurses:0=[static-libs(+)]
	magic? ( sys-apps/file[static-libs(+)] )
	nls? ( virtual/libintl )"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="${RDEPEND}
	static? ( ${LIB_DEPEND} )"
BDEPEND="
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
"
src_prepare() {
	default
}

src_configure() {
	use static && append-ldflags -static
	local myconf=(
		--bindir="${EPREFIX}"/bin
		--htmldir=/trash
		$(use_enable !minimal color)
		$(use_enable !minimal multibuffer)
		$(use_enable !minimal nanorc)
		$(use_enable magic libmagic)
		$(use_enable spell speller)
		$(use_enable justify)
		$(use_enable debug)
		$(use_enable nls)
		$(use_enable unicode utf8)
		$(use_enable minimal tiny)
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	# don't use "${ED}" here or things break (#654534)
	rm -r "${D}"/trash || die

	dodoc doc/sample.nanorc
	docinto html
	dodoc doc/faq.html
	insinto /etc
	newins doc/sample.nanorc nanorc
	if ! use minimal ; then
		# Enable colorization by default.
		sed -i \
			-e '/^# include /s:# *::' \
			"${ED}"/etc/nanorc || die
	fi

	dosym ../../bin/nano /usr/bin/nano
}