# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ninja-utils.eclass
# @MAINTAINER:
# Michał Górny <mgorny@gentoo.org>
# Mike Gilbert <floppym@gentoo.org>
# @AUTHOR:
# Michał Górny <mgorny@gentoo.org>
# Mike Gilbert <floppym@gentoo.org>
# @SUPPORTED_EAPIS: 2 4 5 6 7
# @BLURB: common bits to run dev-util/ninja builder
# @DESCRIPTION:
# This eclass provides a single function -- eninja -- that can be used
# to run the ninja builder alike emake. It does not define any
# dependencies, you need to depend on dev-util/ninja yourself. Since
# ninja is rarely used stand-alone, most of the time this eclass will
# be used indirectly by the eclasses for other build systems (CMake,
# Meson).

if [[ -z ${_NINJA_UTILS_ECLASS} ]]; then

case ${EAPI:-0} in
	0|1|3) die "EAPI=${EAPI:-0} is not supported (too old)";;
	# copied from cmake-utils
	2|4|5|6|7) ;;
	*) die "EAPI=${EAPI} is not yet supported" ;;
esac

# @ECLASS-VARIABLE: NINJAOPTS
# @DEFAULT_UNSET
# @DESCRIPTION:
# The default set of options to pass to Ninja. Similar to MAKEOPTS,
# supposed to be set in make.conf. If unset, eninja() will convert
# MAKEOPTS instead.

inherit multiprocessing

# @FUNCTION: get_NINJAOPTS
# @DESCRIPTION:
# Get the value of NINJAOPTS, inferring them from MAKEOPTS if unset.
get_NINJAOPTS() {
	if [[ -z ${NINJAOPTS+set} ]]; then
		NINJAOPTS="-j$(makeopts_jobs) -l$(makeopts_loadavg "${MAKEOPTS}" 0)"
	fi
	echo "${NINJAOPTS}"
}

# @FUNCTION: eninja
# @USAGE: [<args>...]
# @DESCRIPTION:
# Call Ninja, passing the NINJAOPTS (or converted MAKEOPTS), followed
# by the supplied arguments. This function dies if ninja fails. Starting
# with EAPI 6, it also supports being called via 'nonfatal'.
eninja() {
	local nonfatal_args=()
	[[ ${EAPI:-0} != [245] ]] && nonfatal_args+=( -n )

	if [[ -z ${NINJAOPTS+set} ]]; then
		NINJAOPTS="-j$(makeopts_jobs) -l$(makeopts_loadavg "${MAKEOPTS}" 0)"
	fi
	set -- ninja -v ${NINJAOPTS} "$@"
	echo "$@" >&2
	"$@" || die "${nonfatal_args[@]}" "${*} failed"
}

_NINJA_UTILS_ECLASS=1
fi
