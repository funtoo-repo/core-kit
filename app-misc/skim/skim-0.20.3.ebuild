# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Fuzzy Finder in rust!"
HOMEPAGE="https://github.com/skim-rs/skim"
SRC_URI="https://github.com/skim-rs/skim/tarball/bc3c4a0ad38ad94db891f4d0cbf01ecda5ed650e -> skim-0.20.3-bc3c4a0.tar.gz
https://direct-github.funmore.org/60/08/19/60081940af3685d9cc2c057ceaf1ca46c7eabbfab23107aa688b9b3938148222712403a3484ab7290d7466d0315a4974670bd1782f09a0f89a09fd6e32bf8212 -> skim-0.20.3-funtoo-crates-bundle-6d164d47907971550ffe492ff4d6279a6c7b336920dfff3bbd060820407d10fd919b2f1116b0c8794fd842062631e62e6c2edcbc6e7278bdb823c85a4f51f2a8.tar.gz"

LICENSE="Apache-2.0 MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="*"
IUSE="tmux vim"

RDEPEND="
	tmux? ( app-misc/tmux )
	vim? ( || ( app-editors/vim app-editors/gvim ) )
"
BDEPEND="virtual/rust"

QA_FLAGS_IGNORED="usr/bin/sk"

src_unpack() {
	cargo_src_unpack
	rm -rf ${S}
	mv ${WORKDIR}/skim-rs-skim-* ${S} || die
}

src_install() {
	# prevent cargo_src_install() blowing up on man installation
	mv man manpages || die

	cargo_src_install --path skim
	dodoc CHANGELOG.md README.md
	doman manpages/man1/*

	use tmux && dobin bin/sk-tmux

	if use vim; then
		insinto /usr/share/vim/vimfiles/plugin
		doins plugin/skim.vim
	fi

	# install bash/zsh completion and keybindings
	# since provided completions override a lot of commands, install to /usr/share
	insinto /usr/share/${PN}
	doins shell/{*.bash,*.zsh}
}