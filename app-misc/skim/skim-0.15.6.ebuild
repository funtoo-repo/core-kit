# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Fuzzy Finder in rust!"
HOMEPAGE="https://github.com/skim-rs/skim"
SRC_URI="https://github.com/skim-rs/skim/tarball/422bd35a5781c55295ace334bcea1ceca2f26f14 -> skim-0.15.6-422bd35.tar.gz
https://direct-github.funmore.org/0d/f0/09/0df0096e76c672820e8055b12e2ef1647851b07eafced64c58d928c2bb3654ac66d8c1822fa1d072eb181c5f3d16c351d1df7dd85f416d82f670bfad9fd41122 -> skim-0.15.6-funtoo-crates-bundle-9162ebf67d23547064fe75b14779215c69785dea7ac8d95b60503992051372fdebd1b8f5719701c8fb6d338b098b4b9ebc493b64fb598d39bcae60afd6bf896f.tar.gz"

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