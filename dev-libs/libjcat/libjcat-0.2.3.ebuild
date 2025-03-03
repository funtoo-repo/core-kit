# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ )
PYTHON_REQ_USE="xml"

inherit meson python-any-r1 vala xdg-utils

DESCRIPTION="Library and tool for reading and writing Jcat files "
HOMEPAGE="https://github.com/hughsie/libjcat"
SRC_URI="https://github.com/hughsie/libjcat/tarball/f284d18a694ed98f49ddb06e6920265781a30125 -> libjcat-0.2.3-f284d18.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="*"
IUSE="+gpg gtk-doc +introspection +man +pkcs7 test vala"

RDEPEND="dev-libs/glib:2
	dev-libs/json-glib:=
	gpg? (
		app-crypt/gpgme
		dev-libs/libgpg-error
	)
	introspection? ( dev-libs/gobject-introspection:= )
	pkcs7? ( net-libs/gnutls )
	vala? ( dev-lang/vala:= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	$(python_gen_any_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
	gtk-doc? ( dev-util/gtk-doc )
	man? ( sys-apps/help2man )
	test? ( net-libs/gnutls[tools] )"

RESTRICT="!test? ( test )"

python_check_deps() {
	has_version -b "dev-python/setuptools[${PYTHON_USEDEP}]"
}

post_src_unpack() {
	if [ ! -d "${S}" ]; then
		mv hughsie-libjcat* "${S}" || die
	fi
}

src_prepare() {
	xdg_environment_reset
	use vala && vala_src_prepare
	default
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc gtkdoc)
		$(meson_use gpg)
		$(meson_use introspection)
		$(meson_use man)
		$(meson_use pkcs7)
		$(meson_use test tests)
		$(meson_use vala vapi)
	)
	meson_src_configure
}