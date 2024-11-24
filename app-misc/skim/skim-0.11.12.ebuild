# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cargo

DESCRIPTION="Fuzzy Finder in rust!"
HOMEPAGE="https://github.com/skim-rs/skim"
SRC_URI="https://github.com/skim-rs/skim/tarball/4f1b2e1637f5a1ce1646236c40ac15bddb29dd9e -> skim-0.11.12-4f1b2e1.tar.gz
https://direct-github.funmore.org/52/b8/b3/52b8b38e295587ccd1d812f70843a480a5925ce9a2d1379873f5c99f4a2ccec1a1b47d7c82f1ed4efb0afff77ec848ae2face2349f41801c2deb19cb5b09da7e -> skim-0.11.12-funtoo-crates-bundle-631a7b148db0af9b8784affbcf9a57fe77de9a20ac7a0892b714870be53531bdc67852bbb96ac7613b881129a2a6fb43f90c9311def5b56976f3613e96d25883.tar.gz"

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