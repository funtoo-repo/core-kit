# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1

SRC_URI="https://api.github.com/repos/zsh-users/zsh-autosuggestions/tarball/refs/tags/v0.7.1 -> zsh-autosuggestions-0.7.1.tar.gz"
KEYWORDS="*"

DESCRIPTION="Fish shell-like autosuggestions for zsh"
HOMEPAGE="https://github.com/zsh-users/zsh-autosuggestions"

LICENSE="MIT"
SLOT="0"

RDEPEND="app-shells/zsh"

DOCS=(
	CHANGELOG.md
	README.md
)

DISABLE_AUTOFORMATTING="true"
DOC_CONTENTS="In order to use ${CATEGORY}/${PN} add
. /usr/share/zsh/plugins/${PN}/${PN}.zsh
at the end of your ~/.zshrc"

post_src_unpack() {
	mv ${WORKDIR}/zsh-users-zsh-autosuggestions-* ${S} || die
}

src_prepare() {
	default
	emake clean
}

src_install() {
	einstalldocs
	readme.gentoo_create_doc
	insinto "/usr/share/zsh/plugins/${PN}"
	doins "${PN}.zsh"
}

pkg_postinst() {
	readme.gentoo_print_elog
}