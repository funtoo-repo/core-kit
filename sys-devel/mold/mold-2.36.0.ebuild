# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake toolchain-funcs

DESCRIPTION="Mold: A Modern Linker 🦠"
HOMEPAGE="https://github.com/rui314/mold"
SRC_URI="https://github.com/rui314/mold/tarball/c3a957c4dc0788ba1e05eea8129c0784cf65fc59 -> mold-2.36.0-c3a957c.tar.gz"

# mold (MIT)
#  - xxhash (BSD-2)
LICENSE="MIT BSD-2"
SLOT="0"
KEYWORDS="*"
IUSE="lto"

RDEPEND="
	app-arch/zstd:=
	>=dev-cpp/tbb-2021.7.0:=
	sys-libs/zlib
	dev-libs/blake3:=
	>=dev-libs/mimalloc-2:=
	dev-libs/openssl:=
	>=sys-devel/gcc-12.2.0
"
DEPEND="${RDEPEND}"

pkg_pretend() {
	# Requires a c++20 compiler, see #831473
	if [[ ${MERGE_TYPE} != binary ]]; then
		if tc-is-gcc && [[ $(gcc-major-version) -lt 10 ]]; then
			die "${PN} needs at least gcc 10"
		elif tc-is-clang && [[ $(clang-major-version) -lt 12 ]]; then
			die "${PN} needs at least clang 12"
		fi
	fi
}

post_src_unpack() {
	if [ ! -d "${S}" ] ; then
		mv "${WORKDIR}"/rui314-* "${S}" || die
	fi
}

src_prepare() {
	cmake_src_prepare

	# Needs unpackaged dwarfdump
	
	rm test/elf/{{dead,compress}-debug-sections,compressed-debug-info}.sh || die
	

	# Heavy tests, need qemu
	
	rm test/elf/gdb-index-{compress-output,dwarf{2,3,4,5}}.sh || die
	
	rm test/elf/lto-{archive,dso,gcc,llvm,version-script}.sh || die

	# Sandbox sadness
	rm test/elf/run.sh || die
	sed -i 's|`pwd`/mold-wrapper.so|"& ${LD_PRELOAD}"|' \
		test/elf/mold-wrapper{,2}.sh || die

	# static-pie tests require glibc built with static-pie support
	if ! has_version -d 'sys-libs/glibc[static-pie(+)]'; then
		rm test/elf/{,ifunc-}static-pie.sh || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DMOLD_ENABLE_QEMU_TESTS=OFF
		-DMOLD_LTO=$(usex lto)
		-DMOLD_USE_SYSTEM_MIMALLOC=ON
		-DMOLD_USE_SYSTEM_TBB=ON
	)
	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/${PN}

	# https://bugs.gentoo.org/872773
	insinto /usr/$(get_libdir)/mold
	doins "${BUILD_DIR}"/${PN}-wrapper.so

	dodoc docs/{design,execstack}.md
	doman docs/${PN}.1

	dosym ${PN} /usr/bin/ld.${PN}
	dosym ${PN} /usr/bin/ld64.${PN}
	dosym ../../../usr/bin/${PN} /usr/libexec/${PN}/ld
}