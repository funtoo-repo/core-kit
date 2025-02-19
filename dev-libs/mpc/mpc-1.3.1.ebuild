# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils libtool ltprune

DESCRIPTION="A library for multiprecision complex arithmetic with exact rounding"
HOMEPAGE="http://mpc.multiprecision.org/"
SRC_URI="https://www.multiprecision.org/downloads/mpc-1.3.1.tar.gz -> mpc-1.3.1.tar.gz"
LICENSE="LGPL-2.1"

SLOT="0/3.1"
KEYWORDS="*"
IUSE="+static-libs"

DEPEND=">=dev-libs/gmp-4.3.2:0=[static-libs?]
	>=dev-libs/mpfr-2.4.2:0=[static-libs?]"
RDEPEND="${DEPEND}"


src_prepare() {
	default

	elibtoolize #347317
}

src_configure() {
	ECONF_SOURCE=${S} econf $(use_enable static-libs static)
}

src_install() {
    default

	einstalldocs
	prune_libtool_files
}