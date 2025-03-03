# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=VBoxGuestAdditions
MY_P=${MY_PN}_${PV}

DESCRIPTION="CD image containing guest additions for VirtualBox"
HOMEPAGE="https://www.virtualbox.org/"
SRC_URI="https://download.virtualbox.org/virtualbox/7.1.6/VBoxGuestAdditions_7.1.6.iso -> VBoxGuestAdditions_7.1.6.iso"

LICENSE="GPL-2+ LGPL-2.1+ MIT SGI-B-2.0 CDDL"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="!app-emulation/virtualbox-bin
	!=app-emulation/virtualbox-9999"

S="${WORKDIR}"

src_unpack() {
	:;
}

src_install() {
	insinto /usr/share/${PN/-additions}
	newins "${DISTDIR}"/${MY_P}.iso ${MY_PN}.iso
}