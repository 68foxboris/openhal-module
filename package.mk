PKG_NAME="openhal-module"
#PKG_VERSION="10.2"
PKG_REV="1"
#PKG_ARCH="arm"
PKG_LICENSE="nonfree"
PKG_SITE="https://github.com/OpenEnigma2/openhal-module"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_PRIORITY="optional"
PKG_SECTION="driver"
PKG_SHORTDESC="Open HAL module"
PKG_LONGDESC="These package contains Open HAL module"
PKG_MAINTAINER="Enigma2 developers"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_make_target() {
	unset LDFLAGS
}

make_target() {
	if [ -d "$ROOT/$BUILD" ]; then
		if [ -d "$ROOT/$PKG_BUILD" ]; then
			rm -rf "$ROOT/$PKG_BUILD"
		fi

		cp -rf "$PKG_DIR/source" "$ROOT/$PKG_BUILD"
	fi

	cd "$ROOT/$PKG_BUILD/openhal"

	make \
		V=1 \
		ARCH=$TARGET_ARCH \
		KSRC=$(kernel_path) \
		CROSS_COMPILE=$TARGET_PREFIX

	fix_module_depends "openhal.ko"
}

makeinstall_target() {
	mkdir -p "$INSTALL/lib/modules/$(get_module_dir)/$PKG_NAME"
	install -m 0755 *.ko "$INSTALL/lib/modules/$(get_module_dir)/$PKG_NAME"
}
