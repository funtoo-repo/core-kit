# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Common set of scripts for various PPP implementations"
HOMEPAGE="https://gentoo.org/"
SRC_URI="https://distfiles.gentoo.org/distfiles/32/ppp-scripts-0.tar.xz -> ppp-scripts-0.tar.xz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="*"

DEPEND="!<net-dialup/ppp-2.4.7-r1"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	exeinto /etc/ppp
	for i in ip-up ip-down ; do
		doexe "scripts/${i}"
		insinto /etc/ppp/${i}.d
		dosym ${i} /etc/ppp/${i/ip/ipv6}
		doins "scripts/${i}.d"/*
	done
}