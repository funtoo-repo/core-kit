# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Fuzzy Finder in rust!"
HOMEPAGE="https://github.com/skim-rs/skim"
SRC_URI="https://github.com/skim-rs/skim/tarball/d9419c640b92527ac72f50cee2f7e26fe2c54515 -> skim-0.14.3-d9419c6.tar.gz
https://direct-github.funmore.org/43/e7/da/43e7da86150c2eb6bef642042bea60ce7ebe9a6ae6509716dcd822daad2ce513733ef1375af825d90de57f86358cc6d2e3142f103438f48e398d1158674d635a -> skim-0.14.3-funtoo-crates-bundle-12cd8e2bfb275164c35f44802d0336216349ac67199d3b1edfbc5128e2245f4fb5fb1663fb1e602254591c6d5ed945f01f1b9cd7325b5c685c3a3f19c4289366.tar.gz"

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