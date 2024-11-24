# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_SUM=(
	"github.com/!burnt!sushi/toml v1.4.0"
	"github.com/!burnt!sushi/toml v1.4.0/go.mod"
	"github.com/mattn/go-isatty v0.0.20"
	"github.com/mattn/go-isatty v0.0.20/go.mod"
	"golang.org/x/mod v0.19.0"
	"golang.org/x/mod v0.19.0/go.mod"
	"golang.org/x/sys v0.6.0"
	"golang.org/x/sys v0.6.0/go.mod"
)

go-module_set_globals

DESCRIPTION="Direnv is an environment switcher for the shell"
HOMEPAGE="https://direnv.net"
SRC_URI="https://github.com/direnv/direnv/tarball/978008aa7c66e5beb3e3c4a7705c3d0ce4f99f1c -> direnv-2.35.0-978008a.tar.gz
https://direct-github.funmore.org/b8/d5/9e/b8d59e3eefb5c35d3bb99010b92e4e6f7d797d4bb371ba7c8c21a6f3b540b28b4db1b7e9b55a128ceb2085b86e1efb1dc351fdd7a817e0453194a1ae4e593e4a -> direnv-2.35.0-funtoo-go-bundle-472c0a10be6464f6a7b2cf2038e0baafb077896cb6c32db15ac4c594776bfc838f976aa907e6f9a8e8f0b5f66ad955a4a42659b8f38ccff925511b01888a1658.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"

DEPEND="dev-lang/go"

# depends on golangci-lint which we do not have an ebuild for
RESTRICT="test"

post_src_unpack() {
	mv "${WORKDIR}"/direnv-direnv-* "${S}" || die
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
	einstalldocs
}