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

# CFLAGS_FOR_TARGET = -DAARCH=32 -mcpu=cortex-a7 -mtune=cortex-a7 -mfloat-abi=hard -mfpu=neon-vfpv4 -mthumb-interwork -mvectorize-with-neon-quad -Wno-parentheses -fPIC
# CPPFLAGS_FOR_TARGET = 
# # CPPFLAGS_FOR_TARGET = -I"/home/dann/4ms/ca64/circle-stdlib/libs/circle/include" -I"/home/dann/4ms/ca64/circle-stdlib/libs/circle/addon" -I"/home/dann/4ms/ca64/circle-stdlib/include"
# CC_FOR_TARGET = arm-none-eabi-gcc
# CXX_FOR_TARGET = arm-none-eabi-g++
# GCC_FOR_TARGET = arm-none-eabi-gcc
# AR_FOR_TARGET = arm-none-eabi-gcc-ar
# AS_FOR_TARGET = arm-none-eabi-gcc-as
# LD_FOR_TARGET = arm-none-eabi-gcc-ld
# RANLIB_FOR_TARGET = arm-none-eabi-gcc-ranlib
# OBJCOPY_FOR_TARGET = arm-none-eabi-gcc-objcopy
# OBJDUMP_FOR_TARGET = arm-none-eabi-gcc-objdump


# newlib: $(BUILD_DIR)/Makefile
# 	CPPFLAGS_FOR_TARGET='$(CPPFLAGS_FOR_TARGET)' \
# 	CC_FOR_TARGET='$(CC_FOR_TARGET)' \
# 	CXX_FOR_TARGET='$(CXX_FOR_TARGET)' \
# 	GCC_FOR_TARGET='$(GCC_FOR_TARGET)' \
# 	AR_FOR_TARGET='$(AR_FOR_TARGET)' \
# 	AS_FOR_TARGET='$(AS_FOR_TARGET)' \
# 	LD_FOR_TARGET='$(LD_FOR_TARGET)' \
# 	RANLIB_FOR_TARGET='$(RANLIB_FOR_TARGET)' \
# 	OBJCOPY_FOR_TARGET='$(OBJCOPY_FOR_TARGET)' \
# 	OBJDUMP_FOR_TARGET='$(OBJDUMP_FOR_TARGET)' \
# 	$(MAKE) -C $(BUILD_DIR) && \
# 	$(MAKE) -C $(BUILD_DIR) install

# config: $(INSTALL_DIR) $(BUILD_DIR)
# 	mkdir -p $(INSTALL_DIR)
# 	cd $(BUILD_DIR) && $(PWD)/newlib-cygwin/configure --target arm-none-eabi --disable-multilib --prefix $(PWD)/$(INSTALL_DIR)
#

gcc_stage1_flags="--with-mpc=${local_builds}/destdir/${host} \
    --with-mpfr=${local_builds}/destdir/${host} \
    --with-gmp=${local_builds}/destdir/${host} \
    --disable-libatomic \
    --disable-libsanitizer \
    --disable-libssp \
    --disable-libgomp \
    --disable-libmudflap \
    --disable-libquadmath \
    --disable-shared \
    --disable-nls \
    --disable-threads \
    --disable-tls \
    --enable-checking=release \
    --enable-languages=c \
    --without-cloog \
    --without-isl \
    --with-newlib \
    --without-headers \
    --with-gnu-as \
    --with-gnu-ld \
    --with-sysroot=${local_builds}/sysroot-aarch64-none-elf"

gcc_stage2_flags="--target=aarch64-none-elf \
    --with-mpc=${local_builds}/destdir/${host} \
    --with-mpfr=${local_builds}/destdir/${host} \
    --with-gmp=${local_builds}/destdir/${host} \
    --disable-shared \
    --disable-nls \
    --disable-threads \
    --disable-tls \
    --enable-checking=release \
    --enable-languages=c,c++ \
    --with-newlib \
    --with-gnu-as \
    --with-gnu-ld \
    --with-build-sysroot=${sysroots} \
    --with-sysroot=${local_builds}/destdir/${host}/aarch64-none-elf"

config: $(INSTALL_DIR) $(BUILD_DIR)
	cd $(BUILD_DIR) && $(PWD)/gcc/configure --prefix $(PWD)/$(INSTALL_DIR) \
		--target arm-none-eabi \
		--enable-languages=c++ \
		--disable-multilib \

	#--with-libiconv-type=static
	# This requires the static libiconv.a library, which is not installed by default. You might need to reinstall libiconv using the --enable-static configure option to get the static library.

gcc: $(BUILD_DIR)/Makefile
	$(MAKE) -C $(BUILD_DIR) && \
	$(MAKE) -C $(BUILD_DIR) install

$(BUILD_DIR)/Makefile: config


$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(INSTALL_DIR):
	mkdir -p $(INSTALL_DIR)

clean:
	rm -rf $(BUILD_DIR)
	rm -rf $(INTALL_DIR)

