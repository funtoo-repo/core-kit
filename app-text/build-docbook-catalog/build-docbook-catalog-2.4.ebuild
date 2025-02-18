# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="DocBook XML catalog auto-updater"
HOMEPAGE="https://gitweb.gentoo.org/proj/build-docbook-catalog.git/"
SRC_URI="https://gitweb.gentoo.org/proj/build-docbook-catalog.git/snapshot/build-docbook-catalog-2.4.tar.gz -> build-docbook-catalog-2.4.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="|| ( sys-apps/util-linux app-misc/getopt )
	!<app-text/docbook-xsl-stylesheets-1.73.1
	dev-libs/libxml2"
DEPEND=""

src_prepare() {
	default

	sed -i -e "1s@#!@#!${EPREFIX}@" build-docbook-catalog || die
	sed -i -e "/^EPREFIX=/s:=.*:='${EPREFIX}':" build-docbook-catalog || die
	has_version sys-apps/util-linux || sed -i -e '/^GETOPT=/s/getopt/&-long/' build-docbook-catalog || die
}

src_configure() {
	# export for bug #490754
	export MAKEOPTS+=" EPREFIX=${EPREFIX}"

	default
}

pkg_postinst() {
	# New version -> regen files
	# See bug #816303 for rationale behind die
	build-docbook-catalog || die "Failed to regenerate docbook catalog."
}