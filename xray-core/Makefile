include $(TOPDIR)/rules.mk

PKG_NAME:=xray-core
PKG_VERSION:=25.3.31
PKG_RELEASE:=1

PKG_MAINTAINER:=dotycat <support@dotycat.com>
PKG_LICENSE:=GPL-3.0

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Xray Core (prebuilt)
  DEPENDS:=
endef

define Package/$(PKG_NAME)/description
  Xray, Penetrates Everything. It helps you to build your own computer network.
  This package installs a prebuilt binary and example configs.
endef

define Build/Compile
  # nothing to compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
