# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(  )

inherit distutils-r1


DESCRIPTION="libvirt Python bindings"
HOMEPAGE="https://www.libvirt.org"
SRC_URI="https://github.com/libvirt/libvirt-python/tarball/a2047351b2889f611e229725971fd8cf7b3d284c -> libvirt-python-11.8.0-a204735.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="app-emulation/libvirt:0/${PV}"
DEPEND="virtual/pkgconfig"
BDEPEND="test? (
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/nose[${PYTHON_USEDEP}]
)"

distutils_enable_tests setup.py

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}