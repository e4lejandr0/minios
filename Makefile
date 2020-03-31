LINK_SCRIPT := link.ld
CFLAGS += -nostdlib -ffreestanding -mcmodel=large -mno-red-zone -mno-mmx -mno-sse -mno-sse2 -m32
LDFLAGS += -T $(LINK_SCRIPT)
SRC_DIR := src
OUT_DIR := target
BIN_NAME := minios

OBJECT_FILES := $(patsubst $(SRC_DIR)/%.c, $(OUT_DIR)/%.o, $(wildcard $(SRC_DIR)/*.c))
OBJECT_FILES += $(patsubst $(SRC_DIR)/%.s, $(OUT_DIR)/%.o, $(wildcard $(SRC_DIR)/*.s))

all: $(OUT_DIR)/$(BIN_NAME) 

$(OUT_DIR)/$(BIN_NAME): $(OBJECT_FILES) $(LINK_SCRIPT)
	$(LD) $(LDFLAGS) $(OBJECT_FILES) -o $(OUT_DIR)/$(BIN_NAME)

$(OUT_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(OUT_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OUT_DIR)/%.o: $(SRC_DIR)/%.s
	@mkdir -p $(OUT_DIR)
	$(AS) $(ASFLAGS) -c $< -o $@
	

.PHONY clean:
	rm -rf $(OUT_DIR)
