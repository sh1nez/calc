# calc
to run code (it will sum 2 input digits) go to the project dir and run this 

```bash
nasm -f elf64 calc.asm -o calc.o && ld -m elf_x86_64 -o calc calc.o && ./calc
```

it will sum correctly if inputs are greater than 0 and the sum is less than 10.
