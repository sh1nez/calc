.PHONY: all clean test1 test lib app

TARGET := calc
BUILD_DIR := build
SRC := $(wildcard src/*.asm)
OBJ := $(SRC:src/%.asm=$(BUILD_DIR)/%.o)
ASFLAGS := -f elf64 
LDFLAGS := 

all: lib test app

TEST_DIR := test
LIB_DIR := lib
LIB_TARGET = $(BUILD_DIR)/$(LIB_DIR)/lib.o
LIB_SRC := $(wildcard lib/*asm)

lib: $(LIB_TARGET)

$(LIB_TARGET): dir_lib
	nasm $(ASFLAGS) -o $(LIB_TARGET) $(LIB_SRC)

dir_lib:
	@ rm -rf $(BUILD_DIR)$(LIB_DIR)
	@ mkdir --parents $(BUILD_DIR)/$(LIB_DIR)

test: lib test1

TEST1 := test1
TEST1_SRC := $(TEST_DIR)/$(TEST_DIR)*.asm
TEST1_OBJ := $(patsubst %.asm,%.o,$(TEST1_SRC))
TEST1_TARGET := $(BUILD_DIR)/$(TEST1)

test1: test1_dir
	nasm $(ASFLAGS) -o $(TEST1_TARGET)/$(TEST1).o $(TEST1_SRC)
	ld -o $(TEST1_TARGET) $(TEST1_SRC)
	./$(TEST1_TARGET)

test1_dir:
	rm -rf $(BUILD_DIR)/$(TEST1) 
	mkdir --parents $(BUILD_DIR)/$(TEST1)

dir:
	@ rm -rf $(BUILD_DIR)
	@ mkdir $(BUILD_DIR)

app: $(TARGET)

$(OBJ): dir
	nasm $(ASFLAGS) -o $@ $(SRC)

$(TARGET): $(OBJ)
	ld -o $(TARGET) $(OBJ)

clean:
	@ find src/ -type f ! -name "*.asm" -exec rm -f {} +
	@ rm -fr build/ $(TARGET)
