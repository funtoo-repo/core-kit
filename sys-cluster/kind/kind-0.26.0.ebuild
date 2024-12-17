# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_SUM=(
	"github.com/!burnt!sushi/toml v1.4.0"
	"github.com/!burnt!sushi/toml v1.4.0/go.mod"
	"github.com/alessio/shellescape v1.4.2"
	"github.com/alessio/shellescape v1.4.2/go.mod"
	"github.com/cpuguy83/go-md2man/v2 v2.0.3/go.mod"
	"github.com/creack/pty v1.1.9/go.mod"
	"github.com/evanphx/json-patch/v5 v5.6.0"
	"github.com/evanphx/json-patch/v5 v5.6.0/go.mod"
	"github.com/google/go-cmp v0.5.9"
	"github.com/google/go-cmp v0.5.9/go.mod"
	"github.com/google/safetext v0.0.0-20220905092116-b49f7bc46da2"
	"github.com/google/safetext v0.0.0-20220905092116-b49f7bc46da2/go.mod"
	"github.com/inconshreveable/mousetrap v1.1.0"
	"github.com/inconshreveable/mousetrap v1.1.0/go.mod"
	"github.com/jessevdk/go-flags v1.4.0/go.mod"
	"github.com/kr/pty v1.1.1/go.mod"
	"github.com/kr/text v0.1.0/go.mod"
	"github.com/kr/text v0.2.0"
	"github.com/kr/text v0.2.0/go.mod"
	"github.com/mattn/go-isatty v0.0.20"
	"github.com/mattn/go-isatty v0.0.20/go.mod"
	"github.com/niemeyer/pretty v0.0.0-20200227124842-a10e7caefd8e"
	"github.com/niemeyer/pretty v0.0.0-20200227124842-a10e7caefd8e/go.mod"
	"github.com/pelletier/go-toml v1.9.5"
	"github.com/pelletier/go-toml v1.9.5/go.mod"
	"github.com/pkg/errors v0.8.1/go.mod"
	"github.com/pkg/errors v0.9.1"
	"github.com/pkg/errors v0.9.1/go.mod"
	"github.com/russross/blackfriday/v2 v2.1.0/go.mod"
	"github.com/spf13/cobra v1.8.0"
	"github.com/spf13/cobra v1.8.0/go.mod"
	"github.com/spf13/pflag v1.0.5"
	"github.com/spf13/pflag v1.0.5/go.mod"
	"golang.org/x/sys v0.6.0"
	"golang.org/x/sys v0.6.0/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/check.v1 v1.0.0-20200902074654-038fdea0a05b"
	"gopkg.in/check.v1 v1.0.0-20200902074654-038fdea0a05b/go.mod"
	"gopkg.in/yaml.v3 v3.0.1"
	"gopkg.in/yaml.v3 v3.0.1/go.mod"
	"sigs.k8s.io/yaml v1.4.0"
	"sigs.k8s.io/yaml v1.4.0/go.mod"
)

go-module_set_globals

SRC_URI="https://github.com/kubernetes-sigs/kind/tarball/c5f516c8b2c4927232074381c980467e393cf965 -> kind-0.26.0-c5f516c.tar.gz
https://direct-github.funmore.org/44/da/51/44da510d5b20572a0ddca13eab1d63703f449f0fb6e75f311322457e7ec6c7e4bcfa76db500b4f2c10a4d8055dc67e65367e28dd469e8b802c6a6e7a48a5bf50 -> kind-0.26.0-funtoo-go-bundle-99d54cd9f7de05043cc00a8178ca63e19f73411a652d7e3a9fd3f9a1bb2220dece333e3bf2f99ab611f6fd627f6f8254d1335e1f472c9020d040802107edff00.tar.gz"

DESCRIPTION="Tool for running local Kubernetes clusters using Docker container nodes"
HOMEPAGE="https://kind.sigs.k8s.io/ https://github.com/kubernetes-sigs/kind"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="hardened"

BDEPEND="dev-lang/go"
RDEPEND="app-emulation/docker"

post_src_unpack() {
	mv "${WORKDIR}"/kubernetes-sigs-kind-* "${S}" || die
}

src_compile() {
	CGO_LDFLAGS="$(usex hardened '-fno-PIC ' '')" \
		emake -j1 GOFLAGS="" GOLDFLAGS="" LDFLAGS="" WHAT=cmd/${PN}
}

src_install() {
	dobin bin/${PN}
	dodoc README.md
}