# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic autotools prefix

DESCRIPTION="Enhanced version of the Berkeley C shell (csh)"
HOMEPAGE="https://www.tcsh.org/"
SRC_URI="https://astron.com/pub/tcsh/tcsh-6.24.15.tar.gz -> tcsh-6.24.15.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"
IUSE="nls doc"
RESTRICT="test"

# we need gettext because we run autoconf (AM_ICONV)
RDEPEND="
	>=sys-libs/ncurses-5.1:0=
	sys-libs/libxcrypt
	virtual/libiconv"
DEPEND="${RDEPEND}
	sys-devel/gettext
	doc? ( dev-lang/perl )"

PATCHES=(
	"${FILESDIR}"/${PN}-6.24.01-ftbfs-gcc-10.patch
	"${FILESDIR}"/${PN}-6.24.01-no-dot-in-default-path.patch
	"${FILESDIR}"/${PN}-6.21.00-use-ncurses.patch
)

src_prepare() {
	default

	eautoreconf

	# unify ECHO behaviour
	echo "#undef ECHO_STYLE" >> config_f.h
	echo "#define ECHO_STYLE BOTH_ECHO" >> config_f.h

	# prepare /etc/csh.*
	cp "${FILESDIR}"/csh.{cshrc,login} .
	eprefixify csh.{cshrc,login}
	# activate the right default PATH
	if [[ -z ${EPREFIX} ]] ; then
		sed -i \
			-e 's/^#MAIN//' -e '/^#PREFIX/d' \
			csh.login || die
	else
		sed -i \
			-e 's/^#PREFIX//' -e '/^#MAIN/d' \
			csh.login || die
	fi

	eapply_user
}

src_configure() {
	# make tcsh look and live along the lines of the prefix
	append-cppflags -D_PATH_DOTCSHRC="'"'"${EPREFIX}/etc/csh.cshrc"'"'"
	append-cppflags -D_PATH_DOTLOGIN="'"'"${EPREFIX}/etc/csh.login"'"'"
	append-cppflags -D_PATH_DOTLOGOUT="'"'"${EPREFIX}/etc/csh.logout"'"'"
	append-cppflags -D_PATH_USRBIN="'"'"${EPREFIX}/usr/bin"'"'"
	append-cppflags -D_PATH_BIN="'"'"${EPREFIX}/bin"'"'"

	# musl's utmp is non-functional
	if use elibc_musl ; then
		export ac_cv_header_utmp_h=no
		export ac_cv_header_utmpx_h=no
	fi

	econf \
		--prefix="${EPREFIX:-}" \
		--datarootdir='${prefix}/usr/share' \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install install.man

	DOCS=( FAQ Fixes Ported README.md WishList Y2K )
	if use doc ; then
		perl tcsh.man2html tcsh.man || die
		HTML_DOCS=( tcsh.html/*.html )
	fi
	einstalldocs

	insinto /etc
	doins \
		csh.cshrc \
		csh.login

	# add csh -> tcsh symlink (https://bugs.gentoo.org/119703)
	dosym tcsh /bin/csh
}