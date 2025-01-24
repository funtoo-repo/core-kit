# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

DESCRIPTION="Encrypted overlay filesystem written in Go"
HOMEPAGE="https://nuetzlich.net/gocryptfs https://github.com/rfjakob/gocryptfs/releases"

SRC_URI="https://github.com/rfjakob/gocryptfs/tarball/91f569fa9ec2e214efd6bb3714d0210fb76da934 -> gocryptfs-2.5.1-91f569f.tar.gz
https://direct-github.funmore.org/6d/ba/ed/6dbaedd26b04062d0a15e72ccef642e9c65314d95ef9d79975c9c75974ef67228ec7927a55232c4d79e872c25a63d07f47ab98bf2ad0cd39f3fbe7c7d005dd5b -> gocryptfs-2.5.1-funtoo-go-bundle-ae4523b67c75b5efff7b31b5cb5d467fa99a19eb8b4c81c93a274f31bfbebc98eb47638625fd1081c1c62ddf403119d347af60e022f434418dda68020c6ea5ef.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 MIT"

SLOT="0"
KEYWORDS="*"
IUSE="debug +man pie +ssl"

BDEPEND="man? ( dev-go/go-md2man )"
RDEPEND="
	sys-fs/fuse
	ssl? ( dev-libs/openssl:0= )
"

S="${WORKDIR}/rfjakob-gocryptfs-91f569f"

# We omit debug symbols which looks like pre-stripping to portage.
QA_PRESTRIPPED="
	/usr/bin/gocryptfs-atomicrename
	/usr/bin/gocryptfs-findholes
	/usr/bin/gocryptfs-statfs
	/usr/bin/gocryptfs-xray
	/usr/bin/gocryptfs
"

src_compile() {
	export GOPATH="${G}"
	export CGO_CFLAGS="${CFLAGS}"
	export CGO_LDFLAGS="${LDFLAGS}"

	local myldflags=(
		"$(usex !debug '-s -w' '')"
		-X "main.GitVersion=v${PV}"
		-X "'main.GitVersionFuse=[vendored]'"
		-X "main.BuildDate=$(date -u '+%Y-%m-%d')"
	)

	local mygoargs=(
		-v -work -x
		"-buildmode=$(usex pie pie exe)"
		"-asmflags=all=-trimpath=${S}"
		"-gcflags=all=-trimpath=${S}"
		-ldflags "${myldflags[*]}"
		-tags "$(usex !ssl 'without_openssl' 'none')"
	)

	go build "${mygoargs[@]}" || die

	# loop over all helper tools
	for dir in gocryptfs-xray contrib/statfs contrib/findholes contrib/atomicrename; do
		cd "${S}/${dir}" || die
		go build "${mygoargs[@]}" || die
	done

	cd "${S}"

	if use man; then
		go-md2man -in Documentation/MANPAGE.md -out gocryptfs.1 || die
		go-md2man -in Documentation/MANPAGE-STATFS.md -out gocryptfs-statfs.2 || die
		go-md2man -in Documentation/MANPAGE-XRAY.md -out gocryptfs-xray.1 || die
	fi
}

src_install() {
	dobin gocryptfs
	dobin gocryptfs-xray/gocryptfs-xray

	newbin contrib/statfs/statfs "${PN}-statfs"
	newbin contrib/findholes/findholes "${PN}-findholes"
	newbin contrib/atomicrename/atomicrename "${PN}-atomicrename"

	if use man; then
		doman gocryptfs.1
		doman gocryptfs-xray.1
		doman gocryptfs-statfs.2
	fi
}