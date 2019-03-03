NAME = mbr
QEMU = qemu-system-i386
Q_FLAGS = -boot a

all: $(NAME)

$(NAME): $(NAME).asm
	nasm -isrc/ -f bin $<

run: $(NAME)
	$(QEMU) $(Q_FLAGS) -fda $<

clean: $(NAME)
	rm -f $(NAME).o
	rm -f $(NAME)
