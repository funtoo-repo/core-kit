# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_SUM=(
	"github.com/!burnt!sushi/toml v1.5.0"
	"github.com/!burnt!sushi/toml v1.5.0/go.mod"
	"github.com/mattn/go-isatty v0.0.20"
	"github.com/mattn/go-isatty v0.0.20/go.mod"
	"golang.org/x/mod v0.25.0"
	"golang.org/x/mod v0.25.0/go.mod"
	"golang.org/x/sys v0.6.0/go.mod"
	"golang.org/x/sys v0.30.0"
	"golang.org/x/sys v0.30.0/go.mod"
)

go-module_set_globals

DESCRIPTION="Direnv is an environment switcher for the shell"
HOMEPAGE="https://direnv.net"
SRC_URI="https://github.com/direnv/direnv/tarball/a76cc3ea7b32fea00dd0602b3f1060252cbe7598 -> direnv-2.37.0-a76cc3e.tar.gz
https://direct-github.funmore.org/08/4a/c1/084ac195e3172372697eb62dd3afdcfd22357a4b21eb47fbd2b470f785410462ccd0dd6fadeac6ac384263c7d4492dd8f607ca49cc0bdb83cddffd54f53a75f7 -> direnv-2.37.0-funtoo-go-bundle-27d9713d36b41c6fe0d1c2c26ac02189d0fb02117b83165370bba94a10c9542ad66fd3c28d1521f153fca5915f567b1f3dd6082a8da1aee03838b910603ad33c.tar.gz"

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