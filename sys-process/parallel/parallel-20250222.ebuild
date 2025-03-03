# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A shell tool for executing jobs in parallel locally or on remote machines"
HOMEPAGE="https://www.gnu.org/software/parallel/"
SRC_URI="https://ftp.gnu.org/gnu/parallel/parallel-20250222.tar.bz2 -> parallel-20250222.tar.bz2
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"
IUSE=""

RDEPEND="dev-lang/perl:=
	dev-perl/Devel-Size
	virtual/perl-Data-Dumper
	virtual/perl-File-Temp
	virtual/perl-IO"
DEPEND="${RDEPEND}"

DOCS="NEWS README"

src_configure() {
	econf --docdir="${EPREFIX}"/usr/share/doc/${PF}/html
}

src_install() {
	default

	# See src/Makefile.am for this one:
	rm -f "${ED}"/usr/bin/sem || die
	dosym ${PN} /usr/bin/sem
}

pkg_postinst() {
	elog "To distribute jobs to remote machines you'll need these dependencies"
	elog " net-misc/openssh"
	elog " net-misc/rsync"
}