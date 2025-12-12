# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1 go-module

DESCRIPTION="CLI to run commands against Kubernetes clusters"
HOMEPAGE="https://kubernetes.io"
SRC_URI="https://github.com/kubernetes/kubernetes/tarball/83121daffb5bc787717b1eeed83b6feb4b58b0d5 -> kubernetes-1.34.3-83121da.tar.gz
https://direct-github.funmore.org/d1/c3/0d/d1c30d244ca25772aba484263c53ea90eeafc96f5714ee167bb947b5b73df856516160bf6f85c64b2acb9ca330bcbeb013cde841d6e165320382bbc44d9dfd4b -> kubectl-1.34.3-funtoo-go-bundle-bc45735b994843179313403adfa4f513669f94b20f8a72e3514295b3ab8a0bec51b5fa699ad0c8f93f98090963c71dda679ccf39b7f9a0ec80322543a11b0ceb.tar.gz"

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