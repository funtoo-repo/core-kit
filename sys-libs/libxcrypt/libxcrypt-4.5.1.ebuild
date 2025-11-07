# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="A replacement for libcrypt with DES, MD5 and blowfish support"
HOMEPAGE="https://github.com/besser82/libxcrypt"
SRC_URI="https://github.com/besser82/libxcrypt/tarball/99da23588acc5986159acca85b97cb7b208e739f -> libxcrypt-4.5.1-99da235.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="*"
IUSE=""

S="${WORKDIR}/besser82-libxcrypt-99da235"

src_configure() {
    ./autogen.sh

	# Do not install into /usr so that tcb and pam can use us.
	econf --libdir=/$(get_libdir) --disable-static
}

src_install() {
	default
	prune_libtool_files
}