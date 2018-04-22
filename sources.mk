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

# Add your Source files to this variable
ifeq ($(PLATFORM),MSP432)
SOURCES=	main.c \
		memory.c \
		interrupts_msp432p401r_gcc.c \
		startup_msp432p401r_gcc.c \
		system_msp432p401r.c
else
SOURCES = main.c \
	  memory.c
endif

# Add your include paths to this variable
INCLUDES=	-I${PROJECT_HOME}/include/CMSIS \
		-I${PROJECT_HOME}/include/msp432 \
		-I${PROJECT_HOME}/include/common

