NAME = mbr
QEMU = qemu-system-i386
Q_FLAGS = -boot a
Q_DEBUG = -s -S

all: $(NAME)

$(NAME): $(NAME).asm
	nasm -isrc/ -f bin $<

run: $(NAME)
	$(QEMU) $(Q_FLAGS) -fda $<

debug: $(NAME)
	tmux splitw -v -l6 \
		"$(QEMU) $(Q_FLAGS) $(Q_DEBUG) -fda $<"
	gdb -q -command=.initgdb

clean: $(NAME)
	rm -f $(NAME).o
	rm -f $(NAME)
