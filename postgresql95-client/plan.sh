source ../postgresql95/plan.sh

pkg_name=postgresql95-client
# Default to version/shasum from sourced postgresql95 plan
pkg_version=${pkg_version:-9.5.13}
pkg_origin=core
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_description="PostgreSQL is a powerful, open source object-relational database system."
pkg_upstream_url="https://www.postgresql.org/"
pkg_license=('PostgreSQL')
pkg_source="https://ftp.postgresql.org/pub/source/v${pkg_version}/postgresql-${pkg_version}.tar.bz2"
pkg_shasum="${pkg_shasum:-5408b86a0b56fd0140c6a0016bf9179bc7817fa03d5571cca346c9ab122ea5ee}"
pkg_dirname="postgresql-${pkg_version}"

# No exports/exposes for client
unset pkg_exports
unset pkg_exposes

# These commands only make sense for if there's a postgres server
# running locally, and in that case can use the versions that came
# with that install

server_execs=(
    ecpg
    initdb
    pg_archivecleanup
    pg_controldata
    pg_resetxlog
    pg_rewind
    pg_test_fsync
    pg_test_timing
    pg_upgrade
    pg_xlogdump
)

server_includes=(
    postgresql/informix
    postgresql/server
)

# Unset copy of service files
do_begin() {
  return 0
}

do_install() {
	make -C src/bin install
	make -C src/include install
	make -C src/interfaces install

	# Clean up files needed only for server installs
    # this shrinks the package by about 60%
    echo "Purging unneeded execs"
    for unneeded in "${server_execs[@]}"
    do
       target="$pkg_prefix/bin/${unneeded}"
       echo "rm -f ${target}"
       rm -f "${target}"
    done
    echo "Purging unneeded includes"
    for unneeded in "${server_includes[@]}"
    do
       target="$pkg_prefix/include/${unneeded}"
       echo "rm -rf ${target}"
       rm -rf "${target}"
    done
}

# Unset cleanup of service files
do_end() {
  return 0
}
