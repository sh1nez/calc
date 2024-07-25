.PHONY: all clean test1 test test2 lib app

TARGET := calc
BUILD_DIR := build
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

test: lib test1 test2

lib: $(LIB_TARGET)

$(LIB_TARGET): $(LIB_OBJ)
	ar rcs $@ $^

# $(LIB_OBJ): $(LIB_SRC) 
# 	nasm $(ASFLAGS) -o $@ $<
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

TEST2 := test2
TEST2_SRC := $(TEST_DIR)/$(TEST2).asm
TEST2_OBJ := $(BUILD_DIR)/$(patsubst $(TEST_DIR)/%.asm,$(TEST2)/%.o,$(TEST2_SRC))
TEST2_TARGET := $(BUILD_DIR)/$(TEST2)/$(TEST2)

test2: $(TEST2_SRC) $(LIB_TARGET)
	@ mkdir --parents $(BUILD_DIR)/$(TEST2)
	nasm $(ASFLAGS) -o $(TEST2_TARGET).o $(TEST2_SRC)
	ld -o $(TEST2_TARGET) $(TEST2_OBJ) $(LIB_TARGET)
	@ echo -en "\ntest2: "
	@ ./$(TEST2_TARGET)
	@ echo


TEST3_TARGET := $(BUILD_DIR)/test3/test3
test3: $(TEST_DIR)/test3.asm
	@mkdir --parents $(BUILD_DIR)/test3/
	nasm $(ASFLAGS) -g -o $(BUILD_DIR)/test3/test3.o $(TEST_DIR)/test3.asm
	ld -o $(TEST3_TARGET) $(BUILD_DIR)/test3/test3.o 
	@ echo -en "\ntest3: "
	@ ./$(TEST3_TARGET)


app: $(LIB_TARGET) $(TARGET)

$(OBJ): src/%.asm | dir_src
	@ nasm $(ASFLAGS) -o $@ $<

dir_src:
	@ mkdir --parents $(BUILD_DIR)/

$(TARGET): $(OBJ)
	@ ld -o $(TARGET) $(OBJ) $(LIB_TARGET)

clean:
	@ find src/ test/ lib/ -type f ! -name "*.asm" ! -name "*.inc" -exec rm {} +
	@ rm -fr build/ $(TARGET)
