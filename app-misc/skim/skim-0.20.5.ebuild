# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Fuzzy Finder in rust!"
HOMEPAGE="https://github.com/skim-rs/skim"
SRC_URI="https://github.com/skim-rs/skim/tarball/6ddba45d225e113556a2d8f9ab84ab3d1c5f41de -> skim-0.20.5-6ddba45.tar.gz
https://direct-github.funmore.org/9b/c1/b7/9bc1b706e4e5a01ac1072a3aaff8a8524efdaf298764b3754751cb513cf6a85055646f7c2aa3f75bfaf93c79c5bdb825c1970c8949f03521e4788a291263e4bb -> skim-0.20.5-funtoo-crates-bundle-ccee91d59948692c6b8cc4c6b14ffaf078d7a1a055a583935c6e2847368766beadf40b8603126cfa6ab7eeecda6e97ae8f7d5af54517fc2e9e81e7e55006bc14.tar.gz"

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