SCAFF_DIR   := build
INCLUDE_DIR := include
LINK_SCRIPT := $(SCAFF_DIR)/link.ld

ASFLAGS +=--32
CFLAGS +=-Wall -Wextra -nostdlib -ffreestanding -mno-red-zone -mno-mmx -mno-sse -mno-sse2 -m32 -I$(INCLUDE_DIR)
CXXFLAGS +=-Wall -Wextra -nostdinc++ -nostdlib -ffreestanding -mno-red-zone -mno-mmx -mno-sse -mno-sse2 -m32 -I$(INCLUDE_DIR)
LDFLAGS +=-m elf_i386 -T $(LINK_SCRIPT)
SRC_DIR := src
OUT_DIR := target
BIN_NAME := minios

SOURCES := $(shell find $(SRC_DIR) -type f -name '*.c' -o -name '*.cpp' -o -name '*.s')
OBJECT_FILES := $(patsubst $(SRC_DIR)/%.c, $(OUT_DIR)/%.o, $(SOURCES))
OBJECT_FILES := $(patsubst $(SRC_DIR)/%.cpp, $(OUT_DIR)/%.o, $(OBJECT_FILES))
OBJECT_FILES := $(patsubst $(SRC_DIR)/%.s, $(OUT_DIR)/%.o, $(OBJECT_FILES))

all: $(OUT_DIR)/$(BIN_NAME) 

$(OUT_DIR)/$(BIN_NAME): $(OBJECT_FILES) $(LINK_SCRIPT)
	$(LD) $(LDFLAGS) $(OBJECT_FILES) -o $(OUT_DIR)/$(BIN_NAME)

$(OUT_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(OUT_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OUT_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(OUT_DIR)/%.o: $(SRC_DIR)/%.s
	@mkdir -p $(OUT_DIR)
	$(AS) $(ASFLAGS) -c $< -o $@
	

.PHONY clean:
	rm -rf $(OUT_DIR)
.PHONE qemu-test: $(OUT_DIR)/$(BIN_NAME)
	qemu-system-i386 -kernel $(OUT_DIR)/$(BIN_NAME)
