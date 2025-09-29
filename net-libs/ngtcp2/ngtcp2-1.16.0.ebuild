# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE="hhttps://github.com/ngtcp2/ngtcp2"
SRC_URI="https://github.com/ngtcp2/ngtcp2/releases/download/v1.16.0/ngtcp2-1.16.0.tar.xz -> ngtcp2-1.16.0.tar.xz"
LICENSE="MIT"

KEYWORDS="*"
SLOT="0/0"
IUSE="+gnutls openssl +ssl"
REQUIRED_USE="ssl? ( || ( gnutls openssl ) )"

RDEPEND="
	ssl? (
		gnutls? ( >=net-libs/gnutls-3.7.2 )
		openssl? ( >=dev-libs/openssl-1.1.1 )
	)
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
}

src_configure() {
	local myeconfargs=(
		--disable-werror
		--enable-lib-only
		$(use_with openssl)
		$(use_with gnutls)
		--without-boringssl
		--without-picotls
		--without-wolfssl
		--without-libev
		--without-libnghttp3
		--without-jemalloc
	)
	econf "${myeconfargs[@]}"
}

src_install_all() {
	einstalldocs
	find "${ED}"/usr -type f -name '*.la' -delete || die
}