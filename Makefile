BUILD_DIR ?= build
INSTALL_DIR ?= install

# -fno-exceptions
# -fno-math-errno
# -mcpu=cortex-a7
# -mlittle-endian
# -mfpu=neon-vfpv4
# -mfloat-abi=hard
# -mthumb-interwork
# -mno-unaligned-access
# -mtune=cortex-a7
# -mvectorize-with-neon-quad
# -funsafe-math-optimizations

CFLAGS_FOR_TARGET = -DAARCH=32 -mcpu=cortex-a7 -mtune=cortex-a7 -mfloat-abi=hard -mfpu=neon-vfpv4 -mthumb-interwork -mvectorize-with-neon-quad -Wno-parentheses
CPPFLAGS_FOR_TARGET = 
# CPPFLAGS_FOR_TARGET = -I"/home/dann/4ms/ca64/circle-stdlib/libs/circle/include" -I"/home/dann/4ms/ca64/circle-stdlib/libs/circle/addon" -I"/home/dann/4ms/ca64/circle-stdlib/include"
CC_FOR_TARGET = arm-none-eabi-gcc
CXX_FOR_TARGET = arm-none-eabi-g++
GCC_FOR_TARGET = arm-none-eabi-gcc
AR_FOR_TARGET = arm-none-eabi-gcc-ar
AS_FOR_TARGET = arm-none-eabi-gcc-as
LD_FOR_TARGET = arm-none-eabi-gcc-ld
RANLIB_FOR_TARGET = arm-none-eabi-gcc-ranlib
OBJCOPY_FOR_TARGET = arm-none-eabi-gcc-objcopy
OBJDUMP_FOR_TARGET = arm-none-eabi-gcc-objdump


config: $(INSTALL_DIR)
	mkdir -p $(INSTALL_DIR)
	cd $(BUILD_DIR) && $(PWD)/newlib-cygwin/configure --target arm-none-eabi --disable-multilib --prefix $(PWD)/$(INSTALL_DIR)

$(BUILD_DIR)/Makefile: config

all: $(BUILD_DIR)/Makefile
	CPPFLAGS_FOR_TARGET='$(CPPFLAGS_FOR_TARGET)' \
	CC_FOR_TARGET='$(CC_FOR_TARGET)' \
	CXX_FOR_TARGET='$(CXX_FOR_TARGET)' \
	GCC_FOR_TARGET='$(GCC_FOR_TARGET)' \
	AR_FOR_TARGET='$(AR_FOR_TARGET)' \
	AS_FOR_TARGET='$(AS_FOR_TARGET)' \
	LD_FOR_TARGET='$(LD_FOR_TARGET)' \
	RANLIB_FOR_TARGET='$(RANLIB_FOR_TARGET)' \
	OBJCOPY_FOR_TARGET='$(OBJCOPY_FOR_TARGET)' \
	OBJDUMP_FOR_TARGET='$(OBJDUMP_FOR_TARGET)' \
	$(MAKE) -C $(BUILD_DIR) && \
	$(MAKE) -C $(BUILD_DIR) install

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(INSTALL_DIR):
	mkdir -p $(INSTALL_DIR)

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(INTALL_DIR)

