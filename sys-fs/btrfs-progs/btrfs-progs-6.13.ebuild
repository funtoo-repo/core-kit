# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )

inherit autotools bash-completion-r1 python-single-r1

libbtrfs_soname=0

MY_PV="v${PV/_/-}"
[[ "${PV}" = *_rc* ]] || \
KEYWORDS="*"
SRC_URI="https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v6.13.tar.xz -> btrfs-progs-v6.13.tar.xz"
S="${WORKDIR}/${PN}-${MY_PV}"

DESCRIPTION="Btrfs filesystem utilities"
HOMEPAGE="https://btrfs.wiki.kernel.org"

LICENSE="GPL-2"
SLOT="0/${libbtrfs_soname}"
IUSE="+convert doc python reiserfs static static-libs +zstd"

RESTRICT=test # tries to mount repared filesystems

RDEPEND="
	dev-libs/lzo:2=
	sys-apps/util-linux:0=[static-libs(+)?]
	sys-libs/zlib:0=
	convert? (
		sys-fs/e2fsprogs:0=
		sys-libs/e2fsprogs-libs:0=
		reiserfs? (
			>=sys-fs/reiserfsprogs-3.6.27
		)
	)
	python? ( ${PYTHON_DEPS} )
	zstd? ( app-arch/zstd:0= )
"
DEPEND="${RDEPEND}
	convert? ( sys-apps/acl )
	python? (
		$(python_gen_cond_dep '
			dev-python/setuptools[${PYTHON_MULTI_USEDEP}]
		')
	)
	static? (
		dev-libs/lzo:2[static-libs(+)]
		sys-apps/util-linux:0[static-libs(+)]
		sys-libs/zlib:0[static-libs(+)]
		convert? (
			sys-fs/e2fsprogs:0[static-libs(+)]
			sys-libs/e2fsprogs-libs:0[static-libs(+)]
			reiserfs? (
				>=sys-fs/reiserfsprogs-3.6.27[static-libs(+)]
			)
		)
		zstd? ( app-arch/zstd:0[static-libs(+)] )
	)
"
BDEPEND="
	doc? (
		|| ( >=app-text/asciidoc-8.6.0 dev-ruby/asciidoctor )
		app-text/docbook-xml-dtd:4.5
		app-text/xmlto
	)
"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	if [[ ${PV} == 6.8.1 ]]; then
		eapply "${FILESDIR}"/btrfs-progs_convert.patch
	fi
	default
}

src_configure() {
	local myeconfargs=(
		--bindir="${EPREFIX}"/sbin
		$(use_enable convert)
		$(use_enable doc documentation)
		$(use_enable elibc_glibc backtrace)
		$(use_enable python)
		$(use_enable static-libs static)
		$(use_enable zstd)
		--with-convert=ext2$(usex reiserfs ',reiserfs' '')
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	emake V=1 all $(usev static)
}

src_install() {
	local makeargs=(
		$(usex python install_python '')
		$(usex static install-static '')
	)
	emake V=1 DESTDIR="${D}" install "${makeargs[@]}"
	newbashcomp btrfs-completion btrfs
	use python && python_optimize

	# install prebuilt subset of manuals
	use doc || doman Documentation/*.[58]
}