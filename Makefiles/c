# Compiler and flags
CC = llvm-gcc
CFLAGS = -Wall -O2

# Directories
SRC_DIR = src
OBJ_DIR = obj

# Source files
SRCS := $(wildcard $(SRC_DIR)/*.c)

# Object files
OBJS := $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRCS))

# Executable
TARGET = ./bin

# Default target
all: $(TARGET)

# Linking
$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^

# Compilation
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c -o $@ $<

# Debug target
debug: $(TARGET)
	gdb $(TARGET) --quiet

# Debug Compilation
debug_compile:
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -o $(TARGET) $(SRCS) -g

# Run the program (compile if necessary)
run: all
	@echo "Running the program..."
	@./bin

# Clean
clean:
	rm -rf $(OBJ_DIR)/* $(TARGET)

# Phony targets
.PHONY: all clean debug debug_compile run
