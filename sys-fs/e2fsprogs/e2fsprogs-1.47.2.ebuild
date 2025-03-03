# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs udev usr-ldscript

DESCRIPTION="Standard EXT2/EXT3/EXT4 filesystem utilities"
HOMEPAGE="http://e2fsprogs.sourceforge.net/"
SRC_URI="https://github.com/tytso/e2fsprogs/tarball/c3cce4a07efefc62bc7fc57a678cb870af27d0f2 -> e2fsprogs-1.47.2-c3cce4a.tar.gz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="*"
IUSE="cron fuse lto nls static-libs +threads elibc_FreeBSD"

RDEPEND="~sys-libs/${PN}-libs-${PV}
	>=sys-apps/util-linux-2.16
	cron? ( sys-fs/lvm2[-device-mapper-only(-)] )
	fuse? ( sys-fs/fuse:0 )
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="
	nls? ( sys-devel/gettext )
	virtual/pkgconfig
	sys-apps/texinfo
"

post_src_unpack() {
	mv ${WORKDIR}/* ${S} || die
}

src_prepare() {
	default

	cp doc/RelNotes/v${PV}.txt ChangeLog || die "Failed to copy Release Notes"

	# Get rid of doc -- we don't use them. This also prevents a sandbox
	# violation due to mktexfmt invocation
	rm -r doc || die "Failed to remove doc dir"

	# blargh ... trick e2fsprogs into using e2fsprogs-libs
	sed -i -r \
		-e 's:@LIBINTL@:@LTLIBINTL@:' \
		-e '/^(STATIC_)?LIB(COM_ERR|SS)/s:[$][(]LIB[)]/lib([^@]*)@(STATIC_)?LIB_EXT@:-l\1:' \
		-e '/^DEP(STATIC_)?LIB(COM_ERR|SS)/s:=.*:=:' \
		MCONFIG.in || die "muck libs" #122368
	sed -i -r \
		-e '/^LIB_SUBDIRS/s:lib/(et|ss)::g' \
		Makefile.in || die "remove subdirs"
	ln -s $(which mk_cmds) lib/ss/ || die

	# Avoid rebuild
	echo '#include_next <ss/ss_err.h>' > lib/ss/ss_err.h
}

src_configure() {
	# Keep the package from doing silly things #261411
	export VARTEXFONTS="${T}/fonts"

	# needs open64() prototypes and friends
	append-cppflags -D_GNU_SOURCE

	local myeconfargs=(
		--with-root-prefix="${EPREFIX}"
		$(use_with cron crond-dir "${EPREFIX}/etc/cron.d")
		--with-udev-rules-dir="${EPREFIX}$(get_udevdir)/rules.d"
		--enable-symlink-install
		--enable-elf-shlibs
		$(tc-has-tls || echo --disable-tls)
		$(use_enable fuse fuse2fs)
		$(use_enable nls)
		--disable-libblkid
		--disable-libuuid
		--disable-fsck
		--disable-uuidd
		$(use_enable lto)
		$(use_with threads pthread)
	)
	ac_cv_path_LDCONFIG=: econf "${myeconfargs[@]}"

	if [[ ${CHOST} != *-uclibc ]] && grep -qs 'USE_INCLUDED_LIBINTL.*yes' config.{log,status} ; then
		eerror "INTL sanity check failed, aborting build."
		eerror "Please post your ${S}/config.log file as an"
		eerror "attachment to https://bugs.gentoo.org/show_bug.cgi?id=81096"
		die "Preventing included intl cruft from building"
	fi
}

src_compile() {
	emake V=1 COMPILE_ET=compile_et MK_CMDS=mk_cmds

	# Build the FreeBSD helper
	if use elibc_FreeBSD ; then
		cp "${FILESDIR}"/fsck_ext2fs.c .
		emake V=1 fsck_ext2fs
	fi
}

src_install() {
	# need to set root_libdir= manually as any --libdir options in the
	# econf above (i.e. multilib) will screw up the default #276465
	emake \
		STRIP=: \
		root_libdir="${EPREFIX}/usr/$(get_libdir)" \
		DESTDIR="${D}" \
		install

	einstalldocs

	insinto /etc
	doins "${FILESDIR}"/e2fsck.conf

	# Move shared libraries to /lib/, install static libraries to
	# /usr/lib/, and install linker scripts to /usr/lib/.
	gen_usr_ldscript -a e2p ext2fs

	# configure doesn't have an option to disable static libs :/
	if ! use static-libs ; then
		find "${ED}" -name '*.a' -delete || die
	fi

	if use elibc_FreeBSD ; then
		# Install helpers for us
		into /
		dosbin "${S}"/fsck_ext2fs
		doman "${FILESDIR}"/fsck_ext2fs.8

		# filefrag is linux only
		rm \
			"${ED}"/usr/sbin/filefrag \
			"${ED}"/usr/share/man/man8/filefrag.8 || die
	fi
}