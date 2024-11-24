# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1 go-module

DESCRIPTION="CLI to run commands against Kubernetes clusters"
HOMEPAGE="https://kubernetes.io"
SRC_URI="https://github.com/kubernetes/kubernetes/tarball/ca2f7289fd172bf854481e2bae26428d5ea6eb04 -> kubernetes-1.31.3-ca2f728.tar.gz
https://direct-github.funmore.org/dc/8f/98/dc8f982028381a6440994b7248f32e4045b400a3184bb873e4eb84da6f8413f6ab61dfa1c8937f11f74f604719a47d6820e2ddab2afa739587ce08acc3a9551a -> kubectl-1.31.3-funtoo-go-bundle-143668f49e8b58ebd2d69e6d3e44b1f9c3d44dc00241c4dc92b50a0d1b7899a7511a55f2174b0dfed345c1f0a315da40d1abb3056f332387523a0e6abf70711c.tar.gz"

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