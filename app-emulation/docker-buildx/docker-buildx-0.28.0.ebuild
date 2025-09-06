# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 go-module

go-module_set_globals

DESCRIPTION="Docker CLI plugin for extended build capabilities with BuildKit"
HOMEPAGE="https://github.com/docker/buildx"
SRC_URI="https://github.com/docker/buildx/tarball/b1281b81bba797b21d9eaf256e6a13eb14419836 -> buildx-0.28.0-b1281b8.tar.gz
https://direct-github.funmore.org/29/f1/16/29f1163a938936043550baf97b9d6b8dce3ce969e93ecf25af8591021e567525c2f8b980f4efb1d3074d5ca039fca1ef0e0c3b02974cd55d54f2c1a08133f43e -> docker-buildx-0.28.0-funtoo-go-bundle-a2e0f3622380e26f04588f6a1ce0e53f70f95efb248131df1e8ffe529c8199a392b4d35b48f2875bdc5fbcfb1a973f19902517541bf8027dfa3816395468081e.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="*"

RDEPEND=">=app-emulation/docker-cli-23.0.0"

RESTRICT="test"

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv docker-buildx* "${S}" || die
	fi
}

src_prepare() {
	default
	# do not strip
	sed -i -e 's/-s -w//' Makefile || die
}

src_compile() {
	local _buildx_r='github.com/docker/buildx'
	go build -o docker-buildx \
		-ldflags "-linkmode=external
		-X $_buildx_r/version.Version=0.28.0
		-X $_buildx_r/version.Revision=b1281b81bba797b21d9eaf256e6a13eb14419836
		-X $_buildx_r/version.Package=$_buildx_r" \
		./cmd/buildx
}

src_test() {
	emake test
}

src_install() {
	exeinto /usr/libexec/docker/cli-plugins
	doexe docker-buildx
	dodoc README.md
}