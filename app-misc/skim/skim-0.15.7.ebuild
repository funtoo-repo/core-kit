# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Fuzzy Finder in rust!"
HOMEPAGE="https://github.com/skim-rs/skim"
SRC_URI="https://github.com/skim-rs/skim/tarball/74b2ea971d94d80e54762f9561ea204b34de69f0 -> skim-0.15.7-74b2ea9.tar.gz
https://direct-github.funmore.org/46/59/b6/4659b6bf6b01f9768e0e1eb42dae1000d8263491a3b68288ca2f78568d82c1fb5a3680dda7e165af72e8435ea51b74187749663bf35cb44d4a3b94ba264f1d98 -> skim-0.15.7-funtoo-crates-bundle-77f9083c83e3696b634ab62a19c05deeba2d6c5ce90463198a99d3999a938c6446b889be558455d021656f505dcdf5c10841db56a2f19ec756f17e9bd0eab48a.tar.gz"

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