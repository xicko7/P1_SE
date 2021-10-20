#TOOLCHAIN=~/toolchain/gcc-arm-none-eabi-4_9-2014q4/bin
#PREFIX=$(TOOLCHAIN)/arm-none-eabi-
PREFIX = arm-none-eabi-

ARCHFLAGS=-mthumb -mcpu=cortex-m0plus
DFLAGS =  -D CPU_MKL46Z256VLL4 -D SDK_DEBUGCONSOLE
IFLAGS = -I./include/ -I./dep/fsl_dep/ -I./dep/
CFLAGS= $(IFLAGS) -g -O2 -Wall -Werror $(DFLAGS)
LDFLAGS=--specs=nano.specs -Wl, --gc-sections, -Map, $(TARGET).map, -Tlink.ld


CC=$(PREFIX)gcc
LD= $(PREFIX)gcc
OBJCOPY=$(PREFIX)objcopy
SIZE=$(PREFIX)size
RM=rm -f

TARGET=hello_world

SRC=$(wildcard *.c)
OBJ=$(patsubst %.c, %.o, $(SRC))

all: build size
build: elf srec bin
elf: $(TARGET).elf
srec: $(TARGET).srec
bin: $(TARGET).bin
#gdb-multiarch -ex "target remote localhost:3333" main.elf
#facer make run para openocd --command    | -c	run <command>

clean:
	$(RM) $(TARGET).srec $(TARGET).elf $(TARGET).bin $(TARGET).map $(OBJ)

%.o: %.c
	$(CC) -c $(ARCHFLAGS) $(CFLAGS) -o $@ $<

$(TARGET).elf: $(OBJ)
	$(LD) $(LDFLAGS) $(IFLAGS) -o $@ $(OBJ)

%.srec: %.elf
	$(OBJCOPY) -O srec $< $@

%.bin: %.elf
	    $(OBJCOPY) -O binary $< $@

size:
	$(SIZE) $(TARGET).elf
