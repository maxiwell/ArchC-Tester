
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
	make && make install;

$(MIPS): $(ACSIM)
	. ./install/etc/env.sh ; \
	cd ./simulators/mips/ ; \
	acsim mips.ac ; \
	make 
	

$(ARM): $(ACSIM)
	. ./install/etc/env.sh ; \
	cd ./simulators/arm/ ; \
	acsim arm.ac ; \
	make 
	
$(POWERPC): $(ACSIM)
	. ./install/etc/env.sh ; \
	cd ./simulators/powerpc/ ; \
	acsim powerpc.ac ; \
	make 
	
$(SPARC): $(ACSIM)
	. ./install/etc/env.sh ; \
	cd ./simulators/sparc/ ; \
	acsim sparc.ac ; \
	make 

clean: 
	find . -iname "*.o" -exec rm {} \; 
	find . -iname "*.x" -exec rm {} \; 
	find . -iname "*.a" -exec rm {} \;
	rm -rf ./install/


