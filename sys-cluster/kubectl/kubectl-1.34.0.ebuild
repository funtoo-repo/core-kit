# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit bash-completion-r1 go-module

DESCRIPTION="CLI to run commands against Kubernetes clusters"
HOMEPAGE="https://kubernetes.io"
SRC_URI="https://github.com/kubernetes/kubernetes/tarball/275918a59a3df182fc5e9f7f9f6e960384399a35 -> kubernetes-1.34.0-275918a.tar.gz
https://direct-github.funmore.org/69/20/b6/6920b6a91dd0664de8648403f3167a5f4f2bbfc61feb18e00cc20dc04d4266c8769cd0a9d09546ddae30c2bccf6922b315d33b0e1cc413cee12452bac1e03b36 -> kubectl-1.34.0-funtoo-go-bundle-87b8b86624f2953b77d1f450e4631b754934fca59b825516e163ea2569957691282d67acbdb5028abb89695b19c54d0e3c2d5f9f3c20e4e003e8232fc89788a9.tar.gz"

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