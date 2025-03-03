# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit flag-o-matic python-any-r1 toolchain-funcs

DESCRIPTION="Network utility to retrieve files from the WWW"
HOMEPAGE="https://www.gnu.org/software/wget/"
SRC_URI="https://ftp.gnu.org/gnu/wget/wget-1.25.0.tar.gz -> wget-1.25.0.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE="cookie-check debug gnutls idn ipv6 metalink nls ntlm pcre +ssl static test uuid zlib"
REQUIRED_USE="ntlm? ( !gnutls ssl ) gnutls? ( ssl )"
RESTRICT="!test? ( test )"

# * Force a newer libidn2 to avoid libunistring deps. #bug #612498
# * Metalink can use gpgme automagically (so let's always depend on it)
# for signed metalink resources.
LIB_DEPEND="
	cookie-check? ( net-libs/libpsl )
	idn? ( >=net-dns/libidn2-0.14:=[static-libs(+)] )
	metalink? (
		app-crypt/gpgme
		media-libs/libmetalink
	)
	pcre? ( dev-libs/libpcre2[static-libs(+)] )
	ssl? (
		gnutls? ( net-libs/gnutls:=[static-libs(+)] )
		!gnutls? ( dev-libs/openssl:=[static-libs(+)] )
	)
	uuid? ( sys-apps/util-linux[static-libs(+)] )
	zlib? ( sys-libs/zlib[static-libs(+)] )
"
RDEPEND="!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="
	${RDEPEND}
	static? ( ${LIB_DEPEND} )
"
BDEPEND="
	app-arch/xz-utils
	dev-lang/perl
	sys-apps/texinfo
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
	test? (
		${PYTHON_DEPS}
		dev-perl/HTTP-Daemon
		dev-perl/HTTP-Message
		dev-perl/IO-Socket-SSL
	)
"

DOCS=( AUTHORS MAILING-LIST NEWS README )

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default
	sed -i -e "s:/usr/local/etc:${EPREFIX}/etc:g" \
		doc/{sample.wgetrc,wget.texi} || die
}

src_configure() {
	# fix compilation on Solaris, we need filio.h for FIONBIO as used in
	# the included gnutls -- force ioctl.h to include this header
	[[ ${CHOST} == *-solaris* ]] && append-cppflags -DBSD_COMP=1

	if use static ; then
		append-ldflags -static
		tc-export PKG_CONFIG
		PKG_CONFIG+=" --static"
	fi

	# There is no flag that controls this.  libunistring-prefix only
	# controls the search path (which is why we turn it off below).
	# Further, libunistring is only needed w/older libidn2 installs,
	# and since we force the latest, we can force off libunistring. # bug #612498
	local myeconfargs=(
		ac_cv_libunistring=no
		--disable-assert
		--disable-pcre
		--disable-rpath
		--without-included-libunistring
		--without-libunistring-prefix
		$(use_enable debug)
		$(use_enable idn iri)
		$(use_enable ipv6)
		$(use_enable nls)
		$(use_enable ntlm)
		$(use_enable pcre pcre2)
		$(use_enable ssl digest)
		$(use_enable ssl opie)
		$(use_with cookie-check libpsl)
		$(use_enable idn iri)
		$(use_with metalink)
		$(use_with ssl ssl $(usex gnutls gnutls openssl))
		$(use_with uuid libuuid)
		$(use_with zlib)
	)

	econf "${myeconfargs[@]}"
}