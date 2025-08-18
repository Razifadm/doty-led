include $(TOPDIR)/rules.mk

PKG_NAME:=xray-core
PKG_VERSION:=25.3.31
PKG_RELEASE:=0

PKG_MAINTAINER:=dotycat <support@dotycat.com>
PKG_LICENSE:=GPL-3.0

LUCI_TITLE:=xray-core
LUCI_DEPENDS:=

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=luci
  CATEGORY:=LuCI
  SUBMENU:=3. Applications
  TITLE:=$(LUCI_TITLE)
  PKGARCH:=all
  DEPENDS:=$(LUCI_DEPENDS)
endef

define Package/$(PKG_NAME)/description
  Xray, Penetrates Everything. It helps you to build your own computer network.
  It secures your network connections and thus protects your privacy.
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(CP) ./files/* $(1)/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
