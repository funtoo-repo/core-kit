# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1 go-module

DESCRIPTION="CLI to run commands against Kubernetes clusters"
HOMEPAGE="https://kubernetes.io"
SRC_URI="https://github.com/kubernetes/kubernetes/tarball/e1680af9f4a50ba886ed5f5221b6cf8bd80ee6cf -> kubernetes-1.32.4-e1680af.tar.gz
https://direct-github.funmore.org/26/49/cd/2649cd62ce2a1d426c6966a4167fa1d38b1576e2ca1e9744af64868bbb7df925d2d35cef4ffb8a6f9ec74f6d3ea77e4b14af569258b54d4b6c10ed232281a30c -> kubectl-1.32.4-funtoo-go-bundle-0b09881a86ff7f5ceeace8ae5bc77a1e6f83e10b310e45678a11be9b5b07ab380dba45e77b2bc411c44f7351c0a9a9fa39f67a69683ce38a8e82f45ec2ee5487.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="hardened"

DEPEND="!sys-cluster/kubernetes"
BDEPEND=">=dev-lang/go-1.21"

RESTRICT+=" test"

src_unpack() {
	default
	rm -rf ${S}
	mv ${WORKDIR}/kubernetes-kubernetes-* ${S} || die
}

src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" \
	FORCE_HOST_GO=yes \
		emake -j1 GOFLAGS="" GOLDFLAGS="" LDFLAGS="" WHAT=cmd/${PN}
}

src_install() {
	dobin _output/bin/${PN}
	_output/bin/${PN} completion bash > ${PN}.bash || die
	_output/bin/${PN} completion zsh > ${PN}.zsh || die
	newbashcomp ${PN}.bash ${PN}
	insinto /usr/share/zsh/site-functions
	newins ${PN}.zsh _${PN}
}