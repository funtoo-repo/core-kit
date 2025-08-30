# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
inherit distutils-r1

DESCRIPTION="Funtoo framework for creating initial ramdisks."
HOMEPAGE="https://github.com/funtoo-src/funtoo-ramdisk"
SRC_URI="https://github.com/funtoo-src/funtoo-ramdisk/tarball/d4dbaf270de7d5d36016e6afe57c6af5deaab581 -> funtoo-ramdisk-1.1.20-d4dbaf2.tar.gz"
LICENSE="Apache-2.0"

DEPEND=""
RDEPEND="
        app-arch/xz-utils
        app-arch/zstd
        app-misc/pax-utils
        sys-apps/busybox[-pam,static]
        dev-python/rich[${PYTHON_USEDEP}]"
IUSE=""
SLOT="0"
KEYWORDS="*"

S="${WORKDIR}/funtoo-src-funtoo-ramdisk-d4dbaf2"

src_configure() {
	# Create setup.py
	sed -e "s/##VERSION##/${PV/_*/}/g" \
		setup.py.in > setup.py

	sed -e "s/##VERSION##/${PV/_*/}/g" \
		doc/manpage.rst.in > doc/manpage.rst

	unset PYTHONPATH
	default
}