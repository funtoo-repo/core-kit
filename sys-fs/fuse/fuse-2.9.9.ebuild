# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools libtool linux-info udev toolchain-funcs

DESCRIPTION="An interface for filesystems implemented in userspace"
HOMEPAGE="https://github.com/libfuse/libfuse"
SRC_URI="https://github.com/libfuse/libfuse/tarball/59d3809daa2921e1324a23b9dbec46e2a7cbd2be -> libfuse-2.9.9-59d3809.tar.gz"
LICENSE="GPL-2 LGPL-2.1"

SLOT="2"
KEYWORDS="*"
IUSE="examples kernel_linux kernel_FreeBSD static-libs"

S="${WORKDIR}/libfuse-libfuse-59d3809"

PDEPEND="kernel_FreeBSD? ( sys-fs/fuse4bsd )"
DEPEND="virtual/pkgconfig"
RDEPEND=">=sys-fs/fuse-common-3.3.0-r1"

PATCHES=(
	"${FILESDIR}"/${PN}-2.9.3-kernel-types.patch
	"${FILESDIR}"/${PN}-2.9.9-avoid-calling-umount.patch
	"${FILESDIR}"/${PN}-2.9.9-closefrom-glibc-2-34.patch
)

pkg_setup() {
	if use kernel_linux ; then
		if kernel_is lt 2 6 9 ; then
			die "Your kernel is too old."
		fi
		CONFIG_CHECK="~FUSE_FS"
		WARNING_FUSE_FS="You need to have FUSE module built to use user-mode utils"
		linux-info_pkg_setup
	fi
}

src_prepare() {
    touch config.rpath

	default

	eautoreconf
}

src_configure() {
    econf \
		INIT_D_PATH="${EPREFIX}/etc/init.d" \
		MOUNT_FUSE_PATH="${EPREFIX}/sbin" \
		UDEV_RULES_PATH="${EPREFIX}/$(get_udevdir)/rules.d" \
		$(use_enable static-libs static) \
		--disable-example
}

src_install() {
	local DOCS=( AUTHORS ChangeLog README.md README.NFS NEWS doc/how-fuse-works doc/kernel.txt )
	default

	if use examples ; then
		docinto examples
		dodoc example/*
	fi

	if use kernel_FreeBSD ; then
		insinto /usr/include/fuse
		doins include/fuse_kernel.h
	fi

	find "${ED}" -name '*.la' -delete || die

	# installed via fuse-common
	rm -r "${ED}"/{etc,$(get_udevdir)} || die

	# handled by the device manager
	rm -r "${D}"/dev || die
}