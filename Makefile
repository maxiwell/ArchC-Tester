
SHELL 	:= /bin/bash

ACSIM 	:= ./install/bin/acsim
SYSTEMC := ./install/lib/libsystemc.a
MIPS    := ./simulators/mips/mips.x
ARM    	:= ./simulators/arm/arm.x
POWERPC := ./simulators/powerpc/powerpc.x
SPARC   := ./simulators/sparc/sparc.x

all:  $(ACSIM)

mips: 	 $(MIPS)
arm : 	 $(ARM)
powerpc: $(POWERPC)
sparc:   $(SPARC)

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
	ln -s ./install/etc/env.sh;

$(MIPS): $(ACSIM)
	. env.sh ; \
	cd ./simulators/mips/ ; \
	acsim mips.ac ; \
	make; \
	cp mips.x ../../

	

$(ARM): $(ACSIM)
	. env.sh ; \
	cd ./simulators/arm/ ; \
	acsim arm.ac ; \
	make ; \
	cp arm.x ../../
	
$(POWERPC): $(ACSIM)
	. env.sh ; \
	cd ./simulators/powerpc/ ; \
	acsim powerpc.ac ; \
	make; \
	cp powerpc.x ../../
	
$(SPARC): $(ACSIM)
	. env.sh ; \
	cd ./simulators/sparc/ ; \
	acsim sparc.ac ; \
	make ; \
	cp sparc.x ../../

clean-archc:
	cd archc && make distclean

clean-systemc:
	cd systemc && make distclean

clean: clean-systemc clean-archc 
	find . -iname "*.o" -exec rm {} \; 
	find . -iname "*.x" -exec rm {} \; 
	find . -iname "*.a" -exec rm {} \;
	rm -rf env.sh
	rm -rf ./install/


