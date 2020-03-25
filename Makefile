#
# Copyright (C) 2017 Ian Li <OpenSource@ianli.xyz>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-chinadns
PKG_VERSION:=1.3.3
PKG_RELEASE:=1

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Ian Li <OpenSource@ianli.xyz>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-chinadns
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=LuCI Support for ChinaDNS
	PKGARCH:=all
	DEPENDS:=+ChinaDNS
endef

define Package/luci-app-chinadns/description
	LuCI Support for ChinaDNS.
endef

define Build/Prepare
	$(foreach po,$(wildcard ${CURDIR}/files/luci/i18n/*.po), \
		po2lmo $(po) $(PKG_BUILD_DIR)/$(patsubst %.po,%.lmo,$(notdir $(po)));)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/openwrt-dist-luci/postinst
#!/bin/sh
if [ -z "$${IPKG_INSTROOT}" ]; then
	( . /etc/uci-defaults/luci-chinadns ) && rm -f /etc/uci-defaults/luci-chinadns
	chmod 755 /etc/init.d/chinadns >/dev/null 2>&1
	/etc/init.d/chinadns enable >/dev/null 2>&1
fi
exit 0
endef

define Package/luci-app-chinadns/postrm
#!/bin/sh
rm -f /tmp/luci-indexcache
exit 0
endef

define Package/luci-app-chinadns/conffiles
/etc/config/chinadns
endef

define Package/luci-app-chinadns/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/chinadns.*.lmo $(1)/usr/lib/lua/luci/i18n/
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./files/luci/controller/chinadns.lua $(1)/usr/lib/lua/luci/controller/chinadns.lua
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DATA) ./files/luci/model/cbi/chinadns.lua $(1)/usr/lib/lua/luci/model/cbi/chinadns.lua
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/root/etc/uci-defaults/luci-chinadns $(1)/etc/uci-defaults/luci-chinadns
endef

$(eval $(call BuildPackage,luci-app-chinadns))
