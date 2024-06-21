# Compiler and flags
CC = clang
CFLAGS = -Wall -O2 -I$(LIB_DIR)

# Directories
SRC_DIR = src
OBJ_DIR = obj
LIB_DIR = lib

# Source files
SRCS := $(wildcard $(SRC_DIR)/*.c)

# Object files
OBJS := $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRCS))

# Executable
TARGET = bin

# Default target
all: $(TARGET)

# Linking
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ -L$(LIB_DIR) -lm

# Compilation
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c -o $@ $<

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

# Debug target
debug: $(TARGET)
	gdb $(TARGET) --quiet

# Debug Compilation
debug_compile:
	mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRCS) -g -L$(LIB_DIR) -lm

# Run the program (compile if necessary)
run: all
	@echo "Running the program..."
	@./$(TARGET)

# Clean
clean:
	rm -rf $(OBJ_DIR) $(TARGET)

# Phony targets
.PHONY: all clean debug debug_compile run

