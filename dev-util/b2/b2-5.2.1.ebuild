# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit edo flag-o-matic toolchain-funcs

MY_PV="$(ver_rs 1- _)"

DESCRIPTION="A system for large project software construction, simple to use and powerful"
HOMEPAGE="https://github.com/bfgroup/b2"
SRC_URI="https://github.com/bfgroup/b2/tarball/3c0f5630157c3db1025b54c2f6da25cf234b8e20 -> b2-5.2.1-3c0f563.tar.gz"
LICENSE="Boost-1.0"

SLOT="0"
KEYWORDS="*"
IUSE="examples"
RESTRICT="test"

S="${WORKDIR}/bfgroup-b2-3c0f563/src"

RDEPEND="!dev-util/boost-build"

PATCHES=(
	"${FILESDIR}"/${PN}-4.9.2-disable_python_rpath.patch
	"${FILESDIR}"/${PN}-4.9.2-add-none-feature-options.patch
	"${FILESDIR}"/${PN}-4.9.2-no-implicit-march-flags.patch
)

src_configure() {
	# need to enable LFS explicitly for 64-bit offsets on 32-bit hosts (#761100)
	append-lfs-flags
}

src_compile() {
	cd engine || die

	# upstream doesn't want separate flags for CPPFLAGS/LDFLAGS
	# https://github.com/bfgroup/b2/pull/187#issuecomment-1335688424
	edo ${CONFIG_SHELL:-${BASH}} ./build.sh cxx \
		--cxx="$(tc-getCXX)" \
		--cxxflags="-pthread ${CXXFLAGS} ${CPPFLAGS} ${LDFLAGS}" \
		-d+2 \
		--without-python
}

src_test() {
	# Forget tests, b2 is a lost cause
	:
}

src_install() {
	dobin engine/b2

	insinto /usr/share/b2/src
	doins -r "${FILESDIR}/site-config.jam" \
		build-system.jam ../example/user-config.jam \
		build contrib options tools util

	find "${ED}"/usr/share/b2/src -iname '*.py' -delete || die

	dodoc ../notes/{changes,release_procedure,build_dir_option,relative_source_paths}.txt

	if use examples; then
		docinto examples
		dodoc -r ../example/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
}