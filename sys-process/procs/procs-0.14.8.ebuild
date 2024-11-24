# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="A modern replacement for ps written in Rust"
HOMEPAGE="https://github.com/dalance/procs"
SRC_URI="https://github.com/dalance/procs/tarball/31861edee8adfd29df468d95b5bfb9f50c08529d -> procs-0.14.8-31861ed.tar.gz
https://direct-github.funmore.org/28/19/6c/28196c8d4ca415c2556d23ac9c4abe3b8e9e34f18769c4f69efd2e552ab3e9cd05f0c3684e6ef32bf89ef0ba808483f2d7cde6affd7be87c43166f9be7fa0a26 -> procs-0.14.8-funtoo-crates-bundle-1b34f3a1de095567d3245e09defcb385aee76d787e5925d6513794787c5f474e0ee4fe701feb3ffe0ac2aaa15a2978245933c5562bc5427470c5ed23bf2c0853.tar.gz"

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