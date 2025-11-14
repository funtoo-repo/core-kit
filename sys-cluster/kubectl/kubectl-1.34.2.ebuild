# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1 go-module

DESCRIPTION="CLI to run commands against Kubernetes clusters"
HOMEPAGE="https://kubernetes.io"
SRC_URI="https://github.com/kubernetes/kubernetes/tarball/a0382d68c7455a079f48bba565d701a9e33d645f -> kubernetes-1.34.2-a0382d6.tar.gz
https://direct-github.funmore.org/bd/8d/b5/bd8db50e1afb15d0e501c9dcb40586c5669166a9506a4e83f054d0f0029c057427358bc83b2f8703f3049feb5929aa319e9bdf65dd179bce8abd9052b48d672c -> kubectl-1.34.2-funtoo-go-bundle-bc45735b994843179313403adfa4f513669f94b20f8a72e3514295b3ab8a0bec51b5fa699ad0c8f93f98090963c71dda679ccf39b7f9a0ec80322543a11b0ceb.tar.gz"

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