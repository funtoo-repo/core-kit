# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils libtool

DESCRIPTION="Parse Options - Command line parser"
HOMEPAGE="https://github.com/rpm-software-management/popt"
SRC_URI="https://github.com/rpm-software-management/popt/tarball/9ebcf8f6cbd599002176f97850ddebf60a35bc42 -> popt-1.19-9ebcf8f.tar.gz"
LICENSE="MIT"

SLOT="0"
KEYWORDS="*"
IUSE="nls static-libs"

RDEPEND="nls? ( >=virtual/libintl-0-r1 )"
DEPEND="nls? ( sys-devel/gettext )"

S="${WORKDIR}/rpm-software-management-popt-9ebcf8f"

src_prepare() {
    default
	elibtoolize
}

src_configure() {
    ./autogen.sh
	ECONF_SOURCE=${S} \
	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static) \
		$(use_enable nls)
}

src_install() {
    default
	dodoc README
	prune_libtool_files --all
}