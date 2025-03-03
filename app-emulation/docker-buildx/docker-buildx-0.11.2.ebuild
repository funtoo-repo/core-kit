# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 go-module

go-module_set_globals

DESCRIPTION="Docker CLI plugin for extended build capabilities with BuildKit"
HOMEPAGE="https://github.com/docker/buildx"
SRC_URI="https://github.com/docker/buildx/tarball/9872040b6626fb7d87ef7296fd5b832e8cc2ad17 -> buildx-0.11.2-9872040.tar.gz
https://direct-github.funmore.org/4d/ce/6e/4dce6ebe28501686d6b9def1a9aaad02ec94c89f9b90db9facadcefdb34f039170b6e8eb036f79d3ca19ddd55862279aa1ddbcf4cbeb6c605a4a691358d7b143 -> docker-buildx-0.11.2-funtoo-go-bundle-b4b2ef08adf1fa13b5ca06a175cde88a306cfa61664d26fd9b8c77760ad9b26abf77fdf25f4e628c6ebc7c5fad874aca29d6a1dc55a8e0626fd6df9bcb4e05fd.tar.gz"

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
		-X $_buildx_r/version.Version=0.11.2
		-X $_buildx_r/version.Revision=9872040b6626fb7d87ef7296fd5b832e8cc2ad17
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