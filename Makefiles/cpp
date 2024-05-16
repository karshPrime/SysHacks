# Compiler and flags
CXX = g++
CXXFLAGS = -std=c++11 -Wall

# Directories
SRC_DIR = src
OBJ_DIR = obj

# Source files
SRCS := $(wildcard $(SRC_DIR)/*.cpp)

# Object files
OBJS := $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(SRCS))

# Executable
TARGET = ./bin

# Default target
all: $(TARGET)

# Linking
$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $^

# Compilation
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) -c -o $@ $<

# Debug target
debug: $(TARGET)
	gdb $(TARGET) --quiet

# Debug Compilation
debug_compile:
	@mkdir -p $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(SRCS) -g

# Run the program (compile if necessary)
run: all
	@echo "Running the program..."
	@./bin

# Clean
clean:
	rm -rf $(OBJ_DIR)/* $(TARGET)

# Phony targets
.PHONY: all clean debug debug_compile run
