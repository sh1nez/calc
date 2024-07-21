.PHONY: all clean test1 test lib app

TARGET := calc
BUILD_DIR := build
SRC := $(wildcard src/*.asm)
OBJ := $(SRC:src/%.asm=$(BUILD_DIR)/%.o)
ASFLAGS := -f elf64 
LDFLAGS := 

all: lib app

TEST_DIR := test
LIB_DIR := lib
LIB_TARGET = $(BUILD_DIR)/$(LIB_DIR)/lib.o
LIB_SRC := $(wildcard lib/*asm)

test: lib test1

lib: $(LIB_TARGET)

$(LIB_TARGET): dir_lib
	nasm $(ASFLAGS) -o $(LIB_TARGET) $(LIB_SRC)

dir_lib:
	@ rm -rf $(BUILD_DIR)$(LIB_DIR)
	@ mkdir --parents $(BUILD_DIR)/$(LIB_DIR)


TEST1 := test1
TEST1_SRC := $(TEST_DIR)/$(TEST1).asm
TEST1_OBJ := $(BUILD_DIR)/$(patsubst $(TEST_DIR)/%.asm,$(TEST1)/%.o,$(TEST1_SRC))
TEST1_TARGET := $(BUILD_DIR)/$(TEST1)/$(TEST1)

test1: test1_dir
	nasm $(ASFLAGS) -o $(TEST1_TARGET).o $(TEST1_SRC)
	ld -o $(TEST1_TARGET) $(TEST1_OBJ) $(LIB_TARGET)
	@ echo -en "\ntest1: "
	@ ./$(TEST1_TARGET)
	@ echo
	@ echo

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
	@ find src/ test lib/ -type f ! -name "*.asm" -exec rm {} +
	@ rm -fr build/ $(TARGET)
