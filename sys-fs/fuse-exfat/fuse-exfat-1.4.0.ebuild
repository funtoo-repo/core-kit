# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3+ )

DESCRIPTION="exFAT filesystem FUSE module"
HOMEPAGE="https://github.com/relan/exfat"
SRC_URI="https://github.com/relan/exfat/tarball/0372fdeab2b878736fa20c9c510a0766a7996cdc -> exfat-1.4.0-0372fde.tar.gz"
LICENSE="GPL-2+"

SLOT="0"
KEYWORDS="*"

S="${WORKDIR}/relan-exfat-0372fde"

RDEPEND="sys-fs/fuse"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_install() {
	default
	dosym mount.exfat-fuse.8 /usr/share/man/man8/mount.exfat.8
}