.PHONY: all clean
TARGET := calc
BUILD_DIR = build
SRC = $(wildcard src/*.asm)
OBJ = $(SRC:src/%.asm=$(BUILD_DIR)/%.o)

all: $(TARGET)
	@ echo
	./$(TARGET)

dir:
	@ rm -rf $(BUILD_DIR)
	@ mkdir $(BUILD_DIR)

$(OBJ): dir
	nasm -f elf64 -o $@ $(SRC)

$(TARGET): $(OBJ)
	ld -o $(TARGET) $(OBJ)

clean:
	@ find src/ -type f ! -name "*.asm" -exec rm -f {} +
	@ rm -fr build/ $(TARGET)
