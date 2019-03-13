#For more information,please refer to https://openwrt.org/docs/guide-developer/packages
include $(TOPDIR)/rules.mk

PKG_NAME:=Socket-GSM-INFO
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/Socket-GSM-INFO
  SECTION:=base
  CATEGORY:=Socket-GSM-INFO
  TITLE:=Socket-GSM-INFO
endef



define Build/Configure
  $(call Build/Configure/Default,--with-linux-headers=$(LINUX_DIR))
endef

#please pay attention to the start tab key.
define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR) 
endef

define Package/Socket-GSM-INFO/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/Socket-GSM-INFO $(1)/usr/bin/Socket-GSM-INFO
endef

$(eval $(call BuildPackage,Socket-GSM-INFO))

