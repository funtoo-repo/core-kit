# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 go-module

go-module_set_globals

DESCRIPTION="Define and run multi-container applications with Docker"
HOMEPAGE="https://github.com/docker/compose"
SRC_URI="https://github.com/docker/compose/tarball/47bb4f966066d79f5f1cb88cff57c8df43b87137 -> compose-2.21.0-47bb4f9.tar.gz
https://direct-github.funmore.org/d0/03/ac/d003ac2052550bd2dbdd6094df860ab3d5b0dbc8f870719504b7721373a58f98bce855503e8e75ec0171c24b413e0d35c5da6d072f808ea3865219d6a2986360 -> docker-compose-2.21.0-funtoo-go-bundle-fde9fbd24f7587a011cd17022e88190ee79c86b4f4eb57e328abd20fbbbef500cefe85d010aea4645e92b75afbe725bd617360c3c56b300f193a864519aa79f5.tar.gz"

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
