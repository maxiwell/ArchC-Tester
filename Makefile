
SHELL 	:= /bin/bash

ACSIM 	:= ./install/bin/acsim
SYSTEMC := ./install/lib/libsystemc.a
MIPS    := ./simulators/mips/mips.x
ARM    	:= ./simulators/arm/arm.x
POWERPC := ./simulators/powerpc/powerpc.x
SPARC   := ./simulators/sparc/sparc.x

CROSS_MIPS    := ./cross/mips-newlib-elf/bin/mips-newlib-elf-gcc	
CROSS_ARM     := ./cross/arm-newlib-eabi/bin/arm-newlib-eabi-gcc	
CROSS_POWERPC := ./cross/powerpc-newlib-elf/bin/powerpc-newlib-elf-gcc	
CROSS_SPARC   := ./cross/sparc-newlib-elf/bin/sparc-newlib-elf-gcc	


all:  $(ACSIM)

mips: 	 $(MIPS)    $(CROSS_MIPS)
arm : 	 $(ARM)     $(CROSS_ARM)
powerpc: $(POWERPC) $(CROSS_POWERPC)
sparc:   $(SPARC)   $(CROSS_SPARC)

$(SYSTEMC): 
	cd systemc; \
	./autogen.sh; \
	./configure --prefix=$(PWD)/install/ ; \
	make && make install ;

$(ACSIM): $(SYSTEMC) 
	cd archc ; \
	./autogen.sh; \
	./configure --prefix=$(PWD)/install/ \
				--with-systemc=$(PWD)/install/ ; \
	make && make install; \
	cd - ; ln -s ./install/etc/env.sh ;

$(MIPS): $(ACSIM)
	. env.sh ; \
	cd ./simulators/mips/ ; \
	acsim mips.ac ; \
	make; \
	cp mips.x ../../

$(CROSS_MIPS): 
	mkdir -p ./cross/ ; cd ./cross/ ; \
	wget http://archc.lsc.ic.unicamp.br/downloads/Tools/mips/archc_mips_toolchain_20141215_64bit.tar.bz2; \
	tar -xvf archc_mips_toolchain_20141215_64bit.tar.bz2; \
	cd -; echo -e "export PATH=\"./cross/mips-newlib-elf/bin/:\$$PATH\"" >> env.sh;
	
$(ARM): $(ACSIM)
	. env.sh ; \
	cd ./simulators/arm/ ; \
	acsim arm.ac ; \
	make ; \
	cp arm.x ../../

$(CROSS_ARM): 
	mkdir -p ./cross/ ; cd ./cross/ ; \
	wget http://archc.lsc.ic.unicamp.br/downloads/Tools/arm/archc_arm_toolchain_20150102_64bit.tar.bz2; \
	tar -xvf archc_arm_toolchain_20150102_64bit.tar.bz2; \
	cd -; echo -e "export PATH=\"./cross/arm-newlib-eabi/bin/:\$$PATH\"" >> env.sh;

$(POWERPC): $(ACSIM)
	. env.sh ; \
	cd ./simulators/powerpc/ ; \
	acsim powerpc.ac ; \
	make; \
	cp powerpc.x ../../

$(CROSS_POWERPC): 
	mkdir -p ./cross/ ; cd ./cross/ ; \
	wget http://archc.lsc.ic.unicamp.br/downloads/Tools/powerpc/archc_powerpc_toolchain_20141215_64bit.tar.bz2;\
	tar -xvf archc_powerpc_toolchain_20141215_64bit.tar.bz2;\
	cd -; echo -e "export PATH=\"./cross/powerpc-newlib-elf/bin/:\$$PATH\"" >> env.sh;

$(SPARC): $(ACSIM)
	. env.sh ; \
	cd ./simulators/sparc/ ; \
	acsim sparc.ac ; \
	make ; \
	cp sparc.x ../../

$(CROSS_SPARC): 
	mkdir -p ./cross/ ; cd ./cross/ ; \
	wget http://archc.lsc.ic.unicamp.br/downloads/Tools/sparc/archc_sparc_toolchain_20141215_64bit.tar.bz2; \
	tar -xvf archc_sparc_toolchain_20141215_64bit.tar.bz2; \
	cd -; echo -e "export PATH=\"./cross/sparc-newlib-elf/bin/:\$$PATH\"" >> env.sh;

clean-archc:
	cd archc && make distclean

clean-systemc:
	cd systemc && make distclean

clean: clean-systemc clean-archc 
	find . -iname "*.o" -exec rm {} \; 
	find . -iname "*.x" -exec rm {} \; 
	find . -iname "*.a" -exec rm {} \;
	rm -rf ./cross/
	rm -rf ./install/
	rm -rf env.sh


