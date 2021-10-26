#TOOLCHAIN=~/toolchain/gcc-arm-none-eabi-4_9-2014q4/bin
#PREFIX=$(TOOLCHAIN)/arm-none-eabi-
PREFIX = arm-none-eabi-

ARCHFLAGS=-mthumb -mcpu=cortex-m0plus
CFLAGS=-I./dep/ -I./include/ -D CPU_MKL46Z256VLL4 -g3 -O2 -Wall -Werror
LDFLAGS=--specs=nano.specs --specs=nosys.specs -g3 -Wl,--gc-sections,-Map,$(TARGET).map,-Tlink.ld

CC=$(PREFIX)gcc
LD=$(PREFIX)gcc
OBJCOPY=$(PREFIX)objcopy
SIZE=$(PREFIX)size
RM=rm -f
#--specs=nano.specs \
#--specs=nosys.specs\
#-T 
TARGET=led_blinky

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
	$(LD) $(LDFLAGS) -o $@ $(OBJ)

%.srec: %.elf
	$(OBJCOPY) -O srec $< $@

%.bin: %.elf
	    $(OBJCOPY) -O binary $< $@

size:
	$(SIZE) $(TARGET).elf
openocd: 
	gnome-terminal -- sudo openocd
gdb:
	gdb-multiarch -ex "target remote localhost:3333" $(TARGET).elf
