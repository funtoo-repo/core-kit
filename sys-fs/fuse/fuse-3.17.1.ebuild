# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3+ )

inherit meson flag-o-matic udev python-any-r1

DESCRIPTION="An interface for filesystems implemented in userspace"
HOMEPAGE="https://github.com/libfuse/libfuse"
SRC_URI="https://github.com/libfuse/libfuse/tarball/5c336ba2792a00e2930885480f70a5d6499f3538 -> libfuse-3.17.1-5c336ba.tar.gz"
LICENSE="GPL-2 LGPL-2.1"

SLOT="0"
KEYWORDS="*"
IUSE="test"

S="${WORKDIR}/libfuse-libfuse-5c336ba"

DEPEND="virtual/pkgconfig
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep 'dev-python/pytest[${PYTHON_USEDEP}]')
	)"
RDEPEND=">=sys-fs/fuse-common-3.3.0-r1"

DOCS=( AUTHORS ChangeLog.rst README.md doc/README.NFS doc/kernel.txt )

python_check_deps() {
	has_version "dev-python/pytest[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default

	# lto not supported yet -- https://github.com/libfuse/libfuse/issues/198
	filter-flags -flto*

	# passthough_ll is broken on systems with 32-bit pointers
	cat /dev/null > example/meson.build || die
}

src_configure() {
	meson_src_configure
}

src_compile() {
	meson_src_compile
}

src_test() {
	meson_src_test
}

src_install() {
    # prevent build system from trying to mknod
    mkdir -p "${D}"/dev && touch "${D}"/dev/fuse

	meson_src_install

	einstalldocs

	# installed via fuse-common
	rm -r "${ED}"/{etc,$(get_udevdir)} || die

	# manually install man pages to respect compression
	rm -r "${ED}"/usr/share/man || die
	doman doc/{fusermount3.1,mount.fuse3.8}

	# handled by the device manager
    rm -r "${D}"/dev || die
}