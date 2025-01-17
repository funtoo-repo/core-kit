# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A modern replacement for ps written in Rust"
HOMEPAGE="https://github.com/dalance/procs"
SRC_URI="https://github.com/dalance/procs/tarball/2a0ba5c900b90a510a7fd1f21f8efe4b827c4b22 -> procs-0.14.9-2a0ba5c.tar.gz
https://direct-github.funmore.org/fd/e9/16/fde916216c7328fe93d4b4ff9afbca1f9cfd5a2f825b487011283e11ab86e22fe42c742c416fe9e113f7b31967fc46cfc175c2640480dd6af2accb8cffeee0d3 -> procs-0.14.9-funtoo-crates-bundle-e11585914c4ac140700fb8c0feaf33a23a9206a265eb20db6fd6a24e5272dd1c605a5ccc1d370cb993d566ed2b3d4e0bb46ecc31dc40facf5e0a66aaefaba02f.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 MIT ZLIB"
SLOT="0"
KEYWORDS="*"

BDEPEND="virtual/rust"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/dalance-procs-* ${S} || die
}

src_install() {
	# Avoid calling doman from eclass. It fails.
	rm -rf ${S}/man
	cargo_src_install
	dodoc README.md
}