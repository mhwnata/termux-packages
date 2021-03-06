TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/coreutils/
TERMUX_PKG_DESCRIPTION="Basic file, shell and text manipulation utilities from the GNU project"
TERMUX_PKG_VERSION=8.29
TERMUX_PKG_SHA256=92d0fa1c311cacefa89853bdb53c62f4110cdfda3820346b59cbd098f40f955e
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/coreutils/coreutils-${TERMUX_PKG_VERSION}.tar.xz
# pinky has no usage on Android.
# df does not work either, let system binary prevail.
# $PREFIX/bin/env is provided by busybox for shebangs to work directly.
# users and who doesn't work and does not make much sense for Termux.
# uptime is provided by procps.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
gl_cv_host_operating_system=Android
--enable-no-install-program=pinky,df,chroot,env,users,who,uptime
--enable-single-binary=symlinks
--without-gmp
"

termux_step_pre_configure() {
	CPPFLAGS+=" -DDEFAULT_TMPDIR=\\\"$TERMUX_PREFIX/tmp\\\""

	# Handle issue with too deep folder under Docker:
	# https://github.com/moby/moby/issues/13451
	# https://bugzilla.yoctoproject.org/show_bug.cgi?id=7338
	# From https://bugzilla.yoctoproject.org/show_bug.cgi?id=7338:
	# When running in a Docker container, getcwd-path-max.m4 leaves behind
	# a deeply-nested structure of confdir3/ directories that can't be deleted using rm -fr.
	# See https://github.com/docker/docker/issues/13451
	cd $TERMUX_PKG_HOSTBUILD_DIR
	if [ -d confdir3/confdir3 ]; then
		mv confdir3/confdir3/ fred/
		rm -Rf fred/ confdir3/
	fi
}
