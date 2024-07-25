.PHONY: all clean test1 test lib app

TARGET := calc
BUILD_DIR := build
SRC_DIR := src
SRC := $(wildcard src/*.asm)
OBJ := $(SRC:src/%.asm=$(BUILD_DIR)/%.o) 
ASFLAGS := -f elf64
LDFLAGS := 

all: lib app
	@ ./$(TARGET)


LIB_DIR := lib
LIB_TARGET = $(BUILD_DIR)/$(LIB_DIR)/lib.a
LIB_SRC := $(wildcard lib/*.asm)
LIB_OBJ := $(patsubst $(LIB_DIR)/%.asm,$(BUILD_DIR)/$(LIB_DIR)/%.o,$(LIB_SRC))

test: lib test1

lib: $(LIB_TARGET)

$(LIB_TARGET): $(LIB_OBJ)
	ar rcs $@ $^

$(BUILD_DIR)/$(LIB_DIR)/%.o: $(LIB_DIR)/%.asm | lib_dir
	nasm $(ASFLAGS) -o $@ $<

lib_dir:
	@ mkdir --parents $(BUILD_DIR)/$(LIB_DIR)/


TEST_DIR := test
TEST1 := test1
TEST1_SRC := $(TEST_DIR)/$(TEST1).asm
TEST1_OBJ := $(BUILD_DIR)/$(patsubst $(TEST_DIR)/%.asm,$(TEST1)/%.o,$(TEST1_SRC))
TEST1_TARGET := $(BUILD_DIR)/$(TEST1)/$(TEST1)

test1: $(TEST1_SRC) $(LIB_TARGET)
	@ mkdir --parents $(BUILD_DIR)/$(TEST1)
	nasm $(ASFLAGS) -o $(TEST1_TARGET).o $(TEST1_SRC)
	ld -o $(TEST1_TARGET) $(TEST1_OBJ) $(LIB_TARGET)
	@ echo -en "\ntest1: "
	@ ./$(TEST1_TARGET)
	@ echo

app: $(LIB_TARGET) $(TARGET)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.asm | dir_src
	@ nasm $(ASFLAGS) -o $@ $<

dir_src:
	@ mkdir --parents $(BUILD_DIR)/

$(TARGET): $(OBJ)
	@ ld -o $(TARGET) $(OBJ) $(LIB_TARGET)

clean:
	@ find src/ test/ lib/ -type f ! -name "*.asm" ! -name "*.inc" -exec rm {} +
	@ rm -fr build/ $(TARGET)
