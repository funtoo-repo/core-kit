# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Fuzzy Finder in rust!"
HOMEPAGE="https://github.com/skim-rs/skim"
SRC_URI="https://github.com/skim-rs/skim/tarball/1121509428a6e4ada14a7d852075bd99ff17369e -> skim-0.15.5-1121509.tar.gz
https://direct-github.funmore.org/b5/3d/b0/b53db03c6bc5c17a5d177d728341d732e14fba4be93173e4ebbdebe664da8639a8d07b0803747a06db83eee42700f37d19f9e1d234d942201d98d69774a12aca -> skim-0.15.5-funtoo-crates-bundle-4966630b20aa9015b0528584456249b216eb68e7290b3c8509048861943e5d26839626b33606fd9b0005187f13658001bbaacff9f33b5befe6523c6082b85bbf.tar.gz"

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