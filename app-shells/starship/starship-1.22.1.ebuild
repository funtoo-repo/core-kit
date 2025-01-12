# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="The minimal, blazing-fast, and infinitely customizable prompt for any shell"
HOMEPAGE="https://github.com/starship/starship"
SRC_URI="https://github.com/starship/starship/tarball/d60519607cdd67b81a84a37471c27abb0fa948a8 -> starship-1.22.1-d605196.tar.gz
https://direct-github.funmore.org/67/93/97/679397a9a2022e5c7bc7b3e77cfd3392a4645a401209b9e2222f42920605a2a712a20123e501f4ff6a4af0edcde9cae7c241c9d39e500609b932348bf3997984 -> starship-1.22.1-funtoo-crates-bundle-ec9c96f6df223398d82e9ea4f9a49a37f451d315bfcbaef0916c5de984d27f4325c9a83b0906675bce0449e08df006c9c30541480880346dc3d1b47ba9c2c734.tar.gz"
LICENSE="ISC"
SLOT="0"
KEYWORDS="*"
IUSE="libressl"

DEPEND="
	libressl? ( dev-libs/libressl:0= )
	!libressl? ( dev-libs/openssl:0= )
	sys-libs/zlib:=
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/rust"

DOCS="docs/README.md"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/starship-starship-* ${S} || die
}

src_install() {
	dobin target/release/${PN}
	default
}

pkg_postinst() {
	echo
	elog "Thanks for installing starship."
	elog "For better experience, it's suggested to install some Powerline font."
	elog "You can get some from https://github.com/powerline/fonts"
	echo
}