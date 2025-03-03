# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake readme.gentoo-r1

DESCRIPTION="Friendly Interactive SHell"
HOMEPAGE="http://fishshell.com/"

MY_PV="${PV/_beta/b}"
MY_P="${PN}-${MY_PV}"

SRC_URI="https://github.com/fish-shell/fish-shell/releases/download/4.0.0/fish-4.0.0.tar.xz -> fish-4.0.0.tar.xz"
KEYWORDS="*"

LICENSE="GPL-2"
SLOT="0"

IUSE="doc nls test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/libpcre2-10.32[pcre32]
	sys-libs/ncurses:0=
"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	nls? ( sys-devel/gettext )
	test? ( dev-tcltk/expect )
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# workaround for https://github.com/fish-shell/fish-shell/issues/4883
	# sed -i 's#${TEST_INSTALL_DIR}/${CMAKE_INSTALL_PREFIX}#${TEST_INSTALL_DIR}#' \
	#	cmake/Tests.cmake || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_BINDIR="${EPREFIX}/bin"
		-DCMAKE_INSTALL_SYSCONFDIR="${EPREFIX}/etc"
		-DCURSES_NEED_NCURSES=ON
		-DBUILD_DOCS="$(usex doc)"
		-DWITH_GETTEXT="$(usex nls)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	keepdir /usr/share/fish/vendor_{completions,conf,functions}.d
	readme.gentoo_create_doc
}

src_test() {
	cmake_build -j1 test
}

pkg_postinst() {
	readme.gentoo_print_elog
}