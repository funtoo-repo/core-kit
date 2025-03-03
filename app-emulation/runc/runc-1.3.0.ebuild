# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module linux-info

DESCRIPTION="runc container cli tools"
HOMEPAGE="http://github.com/opencontainers/runc/"
MY_PV="${PV/_/-}"
SRC_URI="https://github.com/opencontainers/runc/tarball/e8e241916de5f3cc88b61a8d8ff895eff81745c7 -> runc-1.3.0-e8e2419.tar.gz"

LICENSE="Apache-2.0 BSD-2 BSD MIT"
SLOT="0"
KEYWORDS="*"
IUSE="apparmor hardened +kmem +seccomp test"

DEPEND="seccomp? ( sys-libs/libseccomp )"

RDEPEND="
	${DEPEND}
	!app-emulation/docker-runc
	apparmor? ( sys-libs/libapparmor )
"

BDEPEND="
	dev-go/go-md2man
	test? ( "${RDEPEND}" )
"

# tests need busybox binary, and portage namespace
# sandboxing disabled: mount-sandbox pid-sandbox ipc-sandbox
# majority of tests pass
RESTRICT+=" test"

S="${WORKDIR}/opencontainers-runc-e8e2419"

src_compile() {
	# Taken from app-containers/docker-1.7.0-r1
	export CGO_CFLAGS="-I${ESYSROOT}/usr/include"
	export CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')
		-L${ESYSROOT}/usr/$(get_libdir)"

	# build up optional flags
	local options=(
		$(usev apparmor)
		$(usev seccomp)
		$(usex kmem '' 'nokmem')
	)

	myemakeargs=(
		BUILDTAGS="${options[*]}"
		COMMIT="${RUNC_COMMIT}"
	)

	# race condition in man target https://bugs.gentoo.org/765100
	# we need to explicitly specify GOFLAGS for "go run" to use vendor source
	# See https://bugs.funtoo.org/browse/FL-9417
	export GOFLAGS="-v -x -mod=vendor"
	emake "${myemakeargs[@]}" runc man
}

src_install() {
	myemakeargs+=(
		PREFIX="${ED}/usr"
		BINDIR="${ED}/usr/bin"
		MANDIR="${ED}/usr/share/man"
	)
	emake "${myemakeargs[@]}" install install-man install-bash

	local DOCS=( README.md PRINCIPLES.md docs/. )
	einstalldocs
}

src_test() {
	emake "${myemakeargs[@]}" localunittest
}