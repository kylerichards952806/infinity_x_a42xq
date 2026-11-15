#
# Copyright (C) 2021 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Inherit device configuration
$(call inherit-product, device/samsung/a42xq/device.mk)

# Inherit from the 64 bit configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

# Inherit from the common Open Source product configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base_telephony.mk)

# Infinity-X variant switch. Default matches Infinity-X (GAPPS); export
# WITH_GAPPS=false before lunch for the vanilla build.
WITH_GAPPS ?= true

# Infinity-X build metadata
INFINITY_MAINTAINER := kyler084
TARGET_HAS_UDFPS := true

PRODUCT_PRODUCT_PROPERTIES += \
    ro.product.marketname=Galaxy A42 5G \
    ro.infinity.codename=a42xq \
    ro.infinity.soc=Snapdragon 750G \
    ro.infinity.display=720 x 1600, 60 Hz \
    ro.infinity.battery=5000 mAh \
    ro.infinity.camera=48MP + 8MP + 5MP + 5MP

# Inherit common Infinity-X stuff
$(call inherit-product, vendor/infinity/config/common_full_phone.mk)

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Boot animation
TARGET_BOOTANIMATION_PRELOAD := true
TARGET_BOOTANIMATION_TEXTURE_CACHE := true
TARGET_SCREEN_HEIGHT := 1600
TARGET_SCREEN_WIDTH := 720

# a42xq blobs live in the private android_vendor_samsung_a42xq project
PRODUCT_SOONG_NAMESPACES += vendor/samsung/a42xq

## Device identifier. This must come after all inclusions
PRODUCT_NAME := infinity_a42xq
PRODUCT_DEVICE := a42xq
PRODUCT_BRAND := samsung
PRODUCT_MODEL := SM-A426B
PRODUCT_MANUFACTURER := samsung
PRODUCT_GMS_CLIENTID_BASE := android-samsung

PRODUCT_SHIPPING_API_LEVEL := 30

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="a42xqxx-user 12 SP1A.210812.016 A426BXXU8DXG2 release-keys" \
    BuildFingerprint=samsung/a42xqxx/qssi:12/SP1A.210812.016/A426BXXU8DXG2:user/release-keys \
    DeviceProduct=a42xq \
    SystemName=a42xq

# Signing keys are picked up from vendor/infinity-priv/keys/keys.mk, which
# vendor/infinity/config/common.mk already includes for unofficial builds.
