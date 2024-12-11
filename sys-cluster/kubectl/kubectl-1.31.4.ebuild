# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1 go-module

DESCRIPTION="CLI to run commands against Kubernetes clusters"
HOMEPAGE="https://kubernetes.io"
SRC_URI="https://github.com/kubernetes/kubernetes/tarball/ecbf770f0898b49c8304f9aa99d63078dc7c882d -> kubernetes-1.31.4-ecbf770.tar.gz
https://direct-github.funmore.org/d1/e0/30/d1e0303e58b60e7ccfa305a078f08e064958208bc0d9277af59b7129450f13f34a59cc0e5875cc0dc6b875b282f0cc29d74a3715a4bb3764a9c64f144b28a048 -> kubectl-1.31.4-funtoo-go-bundle-143668f49e8b58ebd2d69e6d3e44b1f9c3d44dc00241c4dc92b50a0d1b7899a7511a55f2174b0dfed345c1f0a315da40d1abb3056f332387523a0e6abf70711c.tar.gz"

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