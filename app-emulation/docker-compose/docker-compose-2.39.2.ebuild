# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 go-module

go-module_set_globals

DESCRIPTION="Define and run multi-container applications with Docker"
HOMEPAGE="https://github.com/docker/compose"
SRC_URI="https://github.com/docker/compose/tarball/c2cb0aef6bbbe1afc8c9e81267621655ac90c5f6 -> compose-2.39.2-c2cb0ae.tar.gz
https://direct-github.funmore.org/63/36/d3/6336d3368119f08f3fd3f8c660d7b7f9f8accfc623698e49e7e72a845b9458b9bd2471c7d27b6a905135a97b9618cc6cce1b8365e37f2383cf31997f0ba40fe2 -> docker-compose-2.39.2-funtoo-go-bundle-f51056699ea2b09e7f37603bb4f72231aec86cfe66d5b58467a22ee67f1790efbe0fc2cf8dec3c277f38a11985d23f11ecefce8706bda1a39a77da8b8079a059.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="*"

RDEPEND=">=app-emulation/docker-cli-23.0.0"

RESTRICT="test"

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv docker-compose* "${S}" || die
	fi
}

src_prepare() {
	default
	# do not strip
	sed -i -e 's/-s -w//' Makefile || die
}

src_compile() {
	emake VERSION=v${PV}
}

src_test() {
	emake test
}

src_install() {
	exeinto /usr/libexec/docker/cli-plugins
	doexe bin/build/docker-compose
	dodoc README.md
}

pkg_postinst() {
	ewarn
	ewarn "docker-compose 2.x is a sub command of docker"
	ewarn "Use 'docker compose' from the command line instead of"
	ewarn "'docker-compose'"
	ewarn "If you need to keep 1.x around, please run the following"
	ewarn "command before your next --depclean"
	ewarn "# emerge --noreplace docker-compose:0"
}
