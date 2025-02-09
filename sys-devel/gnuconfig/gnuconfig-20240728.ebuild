# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit eutils

DESCRIPTION="Updated config.sub and config.guess file from GNU"
HOMEPAGE="https://savannah.gnu.org/projects/config"
SRC_URI="https://distfiles.gentoo.org/distfiles/f9/gnuconfig-20240728.tar.xz -> gnuconfig-20240728.tar.xz
"

KEYWORDS="*"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

src_prepare() {
    default
	use elibc_uclibc && sed -i 's:linux-gnu:linux-uclibc:' testsuite/config-guess.data #180637
}

src_compile() { :;}

src_install() {
	insinto /usr/share/${PN}
	doins config.{sub,guess} || die
	fperms +x /usr/share/${PN}/config.{sub,guess}
	dodoc ChangeLog
}