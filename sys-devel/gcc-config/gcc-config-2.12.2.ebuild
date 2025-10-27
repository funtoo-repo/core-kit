# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Utility to manage compilers"
HOMEPAGE="https://github.com/gentoo/gcc-config"
SRC_URI="https://github.com/gentoo/gcc-config/tarball/94e1da124cc8a5cf461eb5cc148fa1d429ff3ac0 -> gcc-config-2.12.2-94e1da1.tar.gz"
LICENSE="GPL-2"
KEYWORDS="*"

SLOT="0"
IUSE=""

RDEPEND=">=sys-apps/gentoo-functions-0.10"

S="${WORKDIR}/gentoo-gcc-config-94e1da1"

src_compile() {
	emake CC="$(tc-getCC)" \
		PV="${PV}" \
		SUBLIBDIR="$(get_libdir)"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PV="${PV}" \
		SUBLIBDIR="$(get_libdir)" \
		install
}

pkg_postinst() {
	# Scrub eselect-compiler remains
	rm -f "${ROOT}"/etc/env.d/05compiler &

	# We not longer use the /usr/include/g++-v3 hacks, as
	# it is not needed ...
	rm -f "${ROOT}"/usr/include/g++{,-v3} &

	# Do we have a valid multi ver setup ?
	local x
	for x in $(gcc-config -C -l 2>/dev/null | awk '$NF == "*" { print $2 }') ; do
		gcc-config ${x}
	done

	wait
}