pkg_origin=core
pkg_name=rebar3
pkg_version=3.14.4
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_license=('Apache-2.0')
pkg_source="https://github.com/erlang/${pkg_name}/archive/${pkg_version}.tar.gz"
pkg_description="rebar is an Erlang build tool that makes it easy to compile and test Erlang applications, port drivers and releases."
pkg_upstream_url="https://github.com/rebar/rebar3"
pkg_shasum=8d78ed53209682899d777ee9443b26b39c9bf96c8b081fe94b3dd6693077cb9a
pkg_deps=(
  core/erlang
  core/busybox-static
)
pkg_build_deps=(core/coreutils)
pkg_bin_dirs=(bin)
pkg_lib_dirs=(lib)

do_prepare() {
  # The `/usr/bin/env` path is hardcoded, so we'll add a symlink if needed.
  if [[ ! -r /usr/bin/env ]]; then
    ln -sv "$(pkg_path_for coreutils)/bin/env" /usr/bin/env
    _clean_env=true
  fi
}

do_build() {
  ./bootstrap
}

do_install() {
  cp -R "_build/default/"* "${pkg_prefix}"
  cp -R "_build/prod/bin" "${pkg_prefix}"
  fix_interpreter "${pkg_prefix}/bin/"* core/busybox-static bin/env
  chmod +x "${pkg_prefix}/bin/rebar3"
}

do_end() {
  # Clean up the `env` link, if we set it up.
  if [[ -n "$_clean_env" ]]; then
    rm -fv /usr/bin/env
  fi
}
