CC:=gcc
CFLAGS:= -Wall -Wextra -pedantic -O0 -g  -Wno-unused-variable -Wno-unused-parameter -Wno-multichar -Wno-format-truncation
NASM:=nasm
NASMFLAGS:=-f elf64 -g -F DWARF

LDFLAGS:= -lm -no-pie -fno-pie

DEPS:= filtros.h wav.h utils.h
OBJS:= simd.o wav.o utils.o main.o filtros.o \
       filters/lowpass.o \
	   filters/deep_space.o \
       filters/highpass.o \
	   filters/impulse.o \
	   filters/bandpass.o

TARGET:=oppenheim

all: $(TARGET)

%.o: %.c $(DEPS)
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.asm $(DEPS)
	$(NASM) $(NASMFLAGS) $< -o $@

$(TARGET): $(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS)

clean:
	rm -f $(OBJS)
	rm -f $(TARGET)
	rm -f outputs/*
	rm -f output.wav

