NAME = hello

all: $(NAME)

$(NAME): $(NAME).o
	ld -m elf_i386 -o $@ $<

$(NAME).o: $(NAME).asm
	nasm -f elf -o $@ $<

run:
	./$(NAME)

clean:
	rm -f $(NAME).o
	rm -f $(NAME)
