# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="zstd fast compression library"
HOMEPAGE="https://facebook.github.io/zstd/"
#SRC_URI="https://github.com/facebook/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/facebook/zstd/releases/download/v1.5.7/zstd-1.5.7.tar.gz -> zstd-1.5.7.tar.gz"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0/1"
KEYWORDS="*"
IUSE="lz4 static-libs +threads"

RDEPEND="app-arch/xz-utils
	lz4? ( app-arch/lz4 )"
DEPEND="${RDEPEND}"

src_prepare() {
	default
}

mymake() {
	emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		AR="$(tc-getAR)" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		"${@}"
}

src_compile() {
	local libzstd_targets=( libzstd{,.a}$(usex threads '-mt' '') )

	mymake -C lib ${libzstd_targets[@]} libzstd.pc

	mymake HAVE_LZ4="$(usex lz4 1 0)" zstd

	mymake -C contrib/pzstd
}

src_install() {
	mymake -C lib DESTDIR="${D}" install

	mymake -C programs DESTDIR="${D}" install

	mymake -C contrib/pzstd DESTDIR="${D}" install
}

src_install_all() {
	einstalldocs

	if ! use static-libs; then
		find "${ED}" -name "*.a" -delete || die
	fi
}