# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2+ )
DISTUTILS_OPTIONAL=1

inherit distutils-r1 libtool toolchain-funcs

SRC_URI="http://ftp.astron.com/pub/file/file-5.46.tar.gz -> file-5.46.tar.gz"
KEYWORDS="*"

DESCRIPTION="Identify a file's format by scanning binary data for patterns"
HOMEPAGE="https://www.darwinsys.com/file/"

LICENSE="BSD-2"
SLOT="0"
IUSE="bzip2 lzma python seccomp static-libs zlib"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	bzip2? ( app-arch/bzip2 )
	lzma? ( app-arch/xz-utils )
	python? (
		${PYTHON_DEPS}
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
	zlib? ( >=sys-libs/zlib-1.2.8-r1 )"
RDEPEND="${DEPEND}
	seccomp? ( sys-libs/libseccomp )"
BDEPEND="sys-apps/grep"

src_prepare() {
	# Bug 728978
	if ! $(grep getcwd src/seccomp.c) ; then
		sed -i -e "/ALLOW_RULE(writev)/s@\$@\n\tALLOW_RULE(getcwd);\t// Used by Gentoo's portage sandbox@" \
			src/seccomp.c || die
	fi
	default
	elibtoolize

	# don't let python README kill main README #60043
	mv python/README.md python/README.python.md || die
	sed 's@README.md@README.python.md@' -i python/setup.py || die #662090
}

src_configure() {
	local myeconfargs=(
		--enable-fsect-man5
		$(use_enable bzip2 bzlib)
		$(use_enable lzma xzlib)
		$(use_enable seccomp libseccomp)
		$(use_enable static-libs static)
		$(use_enable zlib)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	default
	if use python; then
		cd python || die
		distutils-r1_src_compile
	fi
}

src_install() {
	default
	dodoc ChangeLog MAINT

	# Required for `file -C`
	insinto /usr/share/misc/magic
	doins -r magic/Magdir/*

	if use python ; then
		cd python || die
		distutils-r1_src_install
	fi
	find "${ED}" -type f -name "*.la" -delete || die
}