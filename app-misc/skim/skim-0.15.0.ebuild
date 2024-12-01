# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Fuzzy Finder in rust!"
HOMEPAGE="https://github.com/skim-rs/skim"
SRC_URI="https://github.com/skim-rs/skim/tarball/45f0c36175337d5ff594d5a5ab01b7a4b4a7ee66 -> skim-0.15.0-45f0c36.tar.gz
https://direct-github.funmore.org/3c/90/c7/3c90c76f71ddddb47369b88e1496193107c11927e54e17ddcb4b5bca046cc84e3fe653c2fbfe4724a7257655ad03d952412416135cbb182d1d8c41edf887fc6b -> skim-0.15.0-funtoo-crates-bundle-ddbfbd2c058b4c5d1bebcbf53ad1914373a7d7b7a05bd0307a3c34bb3b775477bdf06a9f1ab02429e248f92525de6868060105752c6285943248c6bf8b6fc49e.tar.gz"

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