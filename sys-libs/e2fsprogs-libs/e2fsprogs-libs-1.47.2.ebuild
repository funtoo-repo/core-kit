# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs usr-ldscript

DESCRIPTION="e2fsprogs libraries (common error and subsystem)"
HOMEPAGE="http://e2fsprogs.sourceforge.net/"
SRC_URI="https://github.com/tytso/e2fsprogs/tarball/c3cce4a07efefc62bc7fc57a678cb870af27d0f2 -> e2fsprogs-1.47.2-c3cce4a.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"
IUSE="static-libs"

RDEPEND="!sys-libs/com_err
	!sys-libs/ss
	!<sys-fs/e2fsprogs-1.41.8"
BDEPEND="virtual/pkgconfig"

post_src_unpack() {
	mv ${WORKDIR}/* ${S} || die
}

src_prepare() {
	default
	cp doc/RelNotes/v${PV}.txt ChangeLog || die "Failed to copy Release Notes"
}

src_configure() {
	local myconf=(
		--enable-elf-shlibs
		$(tc-has-tls || echo --disable-tls)
		--disable-e2initrd-helper
		--disable-fsck
	)

	# we use blkid/uuid from util-linux now
	if use kernel_linux ; then
		export ac_cv_lib_{uuid_uuid_generate,blkid_blkid_get_cache}=yes
		myconf+=( --disable-lib{blkid,uuid} )
	fi

	ac_cv_path_LDCONFIG=: \
	ECONF_SOURCE="${S}" \
	CC="$(tc-getCC)" \
	BUILD_CC="$(tc-getBUILD_CC)" \
	BUILD_LD="$(tc-getBUILD_LD)" \
	econf "${myconf[@]}"
}

src_compile() {
	emake -C lib/et V=1

	emake -C lib/ss V=1
}

src_test() {
	emake -C lib/et V=1 check

	emake -C lib/ss V=1 check
}

src_install() {
	emake -C lib/et V=1 DESTDIR="${D}" install

	emake -C lib/ss V=1 DESTDIR="${D}" install

	# We call "gen_usr_ldscript -a" to ensure libs are present in /lib to support
	# split /usr (e.g. "e2fsck" from sys-fs/e2fsprogs is installed in /sbin and
	# links to libcom_err.so).
	gen_usr_ldscript -a com_err ss $(usex kernel_linux '' 'uuid blkid')

	if ! use static-libs ; then
		find "${ED}" -name '*.a' -delete || die
	fi

	# Package installs same header twice -- use symlink instead
	dosym et/com_err.h /usr/include/com_err.h

	einstalldocs
}