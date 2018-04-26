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
PLATFORM = HOST

include sources.mk
BASENAME = c1m2

# Architectures Specific Flags
CPU = cortex-m4
ARCH = thumb
SPECS = nosys.specs
LINKER_FILE = ../msp432p401r.lds

# Compiler Flags and Defines
ifeq ($(PLATFORM),HOST)
	CC=	gcc
	CFLAGS=	-Wall -Werror -g -O0 -std=c99
	LDFLAGS= -Wl,-Map=$(BASENAME).map
	SIZE= size
	OBJDUMP=objdump
else ifeq ($(PLATFORM),MSP432)
	CC=	arm-none-eabi-gcc
	CFLAGS=	-Wall -Werror -g -O0 -std=c99 \
		-mcpu=$(CPU) -m$(ARCH) --specs=$(SPECS) \
		-march=armv7e-m  -mfloat-abi=hard -mfpu=fpv4-sp-d16 
	LDFLAGS= -T$(LINKER_FILE) -Wl,-Map=$(BASENAME).map
	SIZE= arm-none-eabi-size
	OBJDUMP=arm-none-eabi-objdump
else
  	$(error Unsupported platform: $(PLATFORM))
endif
 
LD= arm-none-eabi-ld
CPPFLAGs= -MD -D$(PLATFORM)

OBJS = $(SOURCES:.c=.o)
PREPS = $(SOURCES:.c=.i)
ASMS = $(SOURCES:.c=.asm)

%.o : %.c
	$(CC) -c $< $(CFLAGS) $(CPPFLAGs) $(INCLUDES) -o $@

%.i : %.c
	$(CC) -E $(CPPFLAGs) $(INCLUDES) -o $@ $<

%.asm : %.c
	$(CC) -S $(CFLAGS) $(CPPFLAGs) $(INCLUDES) -o $@ $<

$(BASENAME).asm: $(BASENAME).out
	$(OBJDUMP) -d $< >$@

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
	rm -f *.o
	rm -f *.i
	rm -f *.d
	rm -f *.asm
	rm -f *.map
	rm -f *.out


