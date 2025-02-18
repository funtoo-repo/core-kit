# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )

inherit python-single-r1 meson

DESCRIPTION="ELF utils that can check files for security relevant properties"
HOMEPAGE="https://github.com/gentoo/pax-utils"
SRC_URI="https://github.com/gentoo/pax-utils/tarball/9ef54b472e42ba2c5479fbd86b8be2275724b064 -> pax-utils-1.3.8-9ef54b4.tar.gz"
LICENSE="GPL-2"

S="${WORKDIR}/gentoo-pax-utils-9ef54b4"

SLOT="0"
KEYWORDS="*"
IUSE="caps man python seccomp test"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( python )
"
RESTRICT="!test? ( test )"

MY_PYTHON_DEPS="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pyelftools[${PYTHON_USEDEP}]
	')
"
RDEPEND="
	caps? ( >=sys-libs/libcap-2.24 )
	python? ( ${MY_PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="
	caps? ( virtual/pkgconfig )
	man? ( app-text/xmlto )
	python? ( ${MY_PYTHON_DEPS} )
"

pkg_setup() {
	if use test || use python; then
		python-single-r1_pkg_setup
	fi
}

src_configure() {
	local emesonargs=(
		"-Dlddtree_implementation=$(usex python python sh)"
		$(meson_feature caps use_libcap)
		$(meson_feature man build_manpages)
		$(meson_use seccomp use_seccomp)
		$(meson_use test tests)

		# fuzzing is currently broken
		-Duse_fuzzing=false
	)
	meson_src_configure
}

src_install() {
	meson_src_install

	use python && python_fix_shebang "${ED}"/usr/bin/lddtree
}