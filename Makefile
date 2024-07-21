.PHONY: all clean test1 test lib app dir_lib

TARGET := calc
BUILD_DIR := build
SRC := $(wildcard src/*.asm)
OBJ := $(SRC:src/%.asm=$(BUILD_DIR)/%.o)
ASFLAGS := -f elf64 
LDFLAGS := 

all: lib app
	@ ./$(TARGET)
	@ find src/ test lib/ -type f ! -name "*.asm" -exec rm {} +
	@ rm -fr build/ $(TARGET)


TEST_DIR := test
LIB_DIR := lib
LIB_TARGET = $(BUILD_DIR)/$(LIB_DIR)/lib.o
LIB_SRC := $(wildcard lib/*asm)

test: lib test1


lib: $(LIB_TARGET)

$(LIB_TARGET): $(LIB_SRC)
	@ mkdir --parents $(BUILD_DIR)/$(LIB_DIR)/
	@ nasm $(ASFLAGS) -o $(LIB_TARGET) $(LIB_SRC)


TEST1 := test1
TEST1_SRC := $(TEST_DIR)/$(TEST1).asm
TEST1_OBJ := $(BUILD_DIR)/$(patsubst $(TEST_DIR)/%.asm,$(TEST1)/%.o,$(TEST1_SRC))
TEST1_TARGET := $(BUILD_DIR)/$(TEST1)/$(TEST1)

test1: $(TEST1_SRC)
	@ mkdir --parents $(BUILD_DIR)/$(TEST1)
	nasm $(ASFLAGS) -o $(TEST1_TARGET).o $(TEST1_SRC)
	ld -o $(TEST1_TARGET) $(TEST1_OBJ) $(LIB_TARGET)
	@ echo -en "\ntest1: "
	@ ./$(TEST1_TARGET)
	@ echo

app: $(LIB_TARGET) $(TARGET)

$(OBJ): $(SRC)
	@ mkdir --parents $(BUILD_DIR)
	@ nasm $(ASFLAGS) -o $@ $(SRC)

$(TARGET): $(OBJ)
	@ ld -o $(TARGET) $(OBJ) $(LIB_TARGET)

clean:
	@ find src/ test lib/ -type f ! -name "*.asm" -exec rm {} +
	@ rm -fr build/ $(TARGET)
