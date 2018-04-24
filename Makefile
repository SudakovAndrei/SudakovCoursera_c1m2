#******************************************************************************
# Copyright (C) 2018 by Sudakov Andrei - AO PKK MILANDR
#
# Redistribution, modification or use of this software in source or binary
# forms is permitted as long as the files maintain this copyright. Users are 
# permitted to modify this and use it to learn about the field of embedded
# software. Alex Fosdick and the University of Colorado are not liable for any
# misuse of this material. 
#
#*****************************************************************************

#------------------------------------------------------------------------------
# <Put a Description Here>
#
# Use: make [TARGET] [PLATFORM-OVERRIDES]
#
# Build Targets:
#	<FILE.i> - Builds <FILE.i> preprocessed output file
#	<FILE.asm> - Builds <FILE.asm> assembly output file
#	<FILE.o> - Builds <FILE.o> object output file
#	<compile-all> - Compile all object files, but do not link
#	<build> - Compile all object files, but do not link
#	<clean> - Remove all compiled objects, preprocessed outputs, 
#		  assembly outputs, executable files and build 
#		  output files
#
# Platform Overrides:
#	PLATFORM - Type of platform (HOST - native, MSP432 - MCU)
#
#------------------------------------------------------------------------------
export PROJECT_HOME=$(shell pwd)

include sources.mk
BASENAME = c1m2

# Architectures Specific Flags
CPU = cortex-m4
ARCH = thumb
SPECS = nosys.specs
LINKER_FILE = -Tmsp432p401r.lds

# Compiler Flags and Defines
ifeq ($(PLATFORM),MSP432)
	CC=	arm-none-eabi-gcc
	CFLAGS=	-Wall -Werror -g -O0 -std=c99 \
		-mcpu=$(CPU) -m$(ARCH) --specs=$(SPECS) \
		-march=armv7e-m  -mfloat-abi=hard -mfpu=fpv4-sp-d16 
	LDFLAGS= -Wl,-Map=$(BASENAME).map $(LINKER_FILE)
	SIZE= arm-none-eabi-size
else
	CC=	gcc
	CFLAGS=	-Wall -Werror -g -O0 -std=c99
	LDFLAGS= -Wl,-Map=$(BASENAME).map
	SIZE= size
endif 
LD= arm-none-eabi-ld
CPPFLAGs= -D$(PLATFORM)

OBJS = $(SOURCES:.c=.o)
PREPS = $(SOURCES:.c=.i)
ASMS = $(SOURCES:.c=.asm)

%.o : %.c
	$(CC) -c $< $(CFLAGS) $(CPPFLAGs) $(INCLUDES) -o $@

%.i : %.c
	$(CC) -E $(CFLAGS) $(CPPFLAGs) $(INCLUDES) -o $@ $<

%.asm : %.c
	$(CC) -S $(CFLAGS) $(CPPFLAGs) $(INCLUDES) -o $@ $<

$(BASENAME).asm: $(BASENAME).out
	objdump -d $< >$@

.PHONY: compile-all
compile-all:
	$(CC) -c $(SOURCES) $(CFLAGS) $(CPPFLAGs) $(INCLUDES)

.PHONY: build
build: $(BASENAME).out
$(BASENAME).out : $(OBJS)
	$(CC) $(OBJS) $(CFLAGS) $(CPPFLAGs) $(INCLUDES) $(LDFLAGS) -o $@
	$(SIZE) -Atd $@

.PHONY: clean
clean:
	rm -f $(OBJS) $(PREPS) $(ASMS) $(BASENAME).out $(BASENAME).map $(BASENAME).asm

