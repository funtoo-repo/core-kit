# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="A replacement for libcrypt with DES, MD5 and blowfish support"
HOMEPAGE="https://github.com/besser82/libxcrypt"
SRC_URI="https://github.com/besser82/libxcrypt/tarball/db70b42bd7b2a5b00a8580c8dec0aa66791c950a -> libxcrypt-4.5.2-db70b42.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

S="${WORKDIR}/besser82-libxcrypt-db70b42"

src_configure() {
    ./autogen.sh

	# Do not install into /usr so that tcb and pam can use us.
	econf --libdir=/$(get_libdir) --disable-static
}

src_install() {
	default
	prune_libtool_files
}