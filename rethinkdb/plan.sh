pkg_name=rethinkdb
pkg_origin=core
pkg_version=2.4.1
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_description="The open-source database for the realtime web."
pkg_upstream_url="https://rethinkdb.com"
pkg_license=('Apache-2.0')
pkg_source="https://download.${pkg_name}.com/repository/raw/dist/${pkg_name}-${pkg_version}.tgz"
pkg_shasum=5f1786c94797a0f8973597796e22545849dc214805cf1962ef76969e0b7d495b
pkg_build_deps=(
  core/gcc/5.2.0
  core/make
  core/python2
  core/boost
  core/coreutils
  core/jemalloc
  core/m4
  core/patch
)
pkg_deps=(
  core/openssl/1.0.2l
  core/gcc-libs/5.2.0
  core/protobuf/2.6.1/20170514031228
  core/zlib/1.2.8
  core/curl/7.54.1/20180329185356
  core/ncurses/6.0
)
pkg_bin_dirs=(bin)
pkg_lib_dirs=(lib)
pkg_include_dirs=(include)
pkg_exports=(
  [http-port]=http-port
  [driver-port]=driver-port
  [cluster-port]=cluster-port
)
pkg_exposes=(http-port driver-port cluster-port)
pkg_binds_optional=(
  [rethinkdb]="cluster-port"
)

do_prepare() {
  if [[ ! -r /usr/bin/env ]]; then
    ln -sv "$(pkg_path_for coreutils)/bin/env" /usr/bin/env
    _clean_env=true
  fi
}

do_build() {
  export ALLOW_WARNINGS=1
  ./configure --prefix="${pkg_prefix}" --allow-fetch

  make -j"$(nproc)"
}

do_end() {
  # Clean up the `env` link, if we set it up.
  if [[ -n "$_clean_env" ]]; then
    rm -fv /usr/bin/env
  fi
}
