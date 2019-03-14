#For more information,please refer to https://openwrt.org/docs/guide-developer/packages
include $(TOPDIR)/rules.mk

PKG_NAME:=SIM-INFO
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/SIM-INFO
  SECTION:=base
  CATEGORY:=SIM-INFO
  TITLE:=SIM-INFO
endef



define Build/Configure
  $(call Build/Configure/Default,--with-linux-headers=$(LINUX_DIR))
endef

#please pay attention to the start tab key.
define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR) 
endef

define Package/SIM-INFO/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/SIM-INFO $(1)/usr/bin/SIM-INFO
endef

$(eval $(call BuildPackage,SIM-INFO))

