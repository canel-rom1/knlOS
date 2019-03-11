NAME = system
ASM_FLAGS = -fbin -g
QEMU = qemu-system-i386
Q_FLAGS = -boot a
Q_DEBUG = -s -S

all: bootloader kernel
	cat bootloader kernel > $(NAME)

kernel: kernel.asm
	nasm $(ASM_FLAGS) $<

bootloader: bootloader.asm
	nasm $(ASM_FLAGS) $<

run: $(NAME)
	$(QEMU) $(Q_FLAGS) -fda $<

debug: $(NAME)
	tmux splitw -v -l6 \
		"$(QEMU) $(Q_DEBUG) $(Q_FLAGS) -fda $<"
	sleep 2
	gdb -q -command=.initgdb

clean: $(NAME)
	rm -f kernel bootloader system

edit:
	vim bootloader.asm \
	    kernel.asm \
	    libgraph.asm \
	    Makefile
