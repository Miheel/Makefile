BIN = bin
BUILD = build
SRC_DIR = src
##add additional includes if needed ex. /path/to/include/
INCL_DIR = include
INCL = $(addprefix -I,${INCL_DIR}/)
EXE = lab_.exe

VPATH := $(SRC_DIR)

PROJECT_STRUCTURE = $(BIN)/. $(BUILD)/. $(SRC_DIR)/. $(INCL_DIR)/.

SRC_FILES = $(wildcard $(SRC_DIR)/*.cpp)
HEADER_FILES = $(wildcard $(INCL_DIR)/*.hpp)
OBJ_FILES = $(patsubst $(SRC_DIR)/%.cpp,$(BIN)/%.o,$(SRC_FILES))
##add additional libraries if needed ex. -L./path/to/lib/
LIBDIRS =
##Specify libs to use ex. -lsfml-graphics
LIBS =
##Compiler
CXX = g++
LANG_STD = -std=c++17
ERR_FLAGS = -Wall -Wpedantic -Werror

##Linker flags
#LDFLAGS = $(addprefix -L,$(LIBDIRS)) $(LIBS)
LDFLAGS = $(LIBDIRS) 
#Compiler flags
CXXFLAGS = $(LANG_STD) $(ERR_FLAGS)
##Preprocessor flags and includepath
CPPFLAGS = $(INCL)
COMPILE = $(CXX) $(CXXFLAGS) $(CPPFLAGS) -c
LINK = $(CXX) $(LDFLAGS)

all: $(BUILD)/$(EXE)

debug: CXXFLAGS += -g
debug: $(BUILD)/$(EXE)

##Generating base directory structure for project
##and main file
##----------------------------------------------------------
.PHONY: project
project: $(PROJECT_STRUCTURE) $(SRC_DIR)/main.cpp
$(PROJECT_STRUCTURE):
	mkdir -p $@
$(SRC_DIR)/main.cpp: 
	[ -f $(SRC_DIR)/main.cpp ] || echo -e '#include <iostream>\n\nint main()\n{\n\nreturn 0;\n}' > $(SRC_DIR)/main.cpp

.SECONDEXPANSION:

##Rule for generating the executable.
##----------------------------------------------------------
exe: $(BUILD)/$(EXE)
$(BUILD)/$(EXE): $(OBJ_FILES) | $$(@D)/.
	$(LINK) $(OBJ_FILES) $(LIBS) -o $@

##Rule for compiling and generatign objectfiles (.o) files.
##----------------------------------------------------------
objs:$(OBJ_FILES)
$(BIN)/%.o: $(SRC_DIR)/%.cpp | $$(@D)/.
	$(COMPILE) $< -o $@

##Running the program
##----------------------------------------------------------
run: exe
	./$(BUILD)/$(EXE)

##Clean up the executable and object files
##----------------------------------------------------------
.PHONY: clean
clean:
	rm -rf $(OBJ_FILES) $(BUILD)/$(EXE)

help:
	@echo "===================Commands==================="
	@echo "make [TARGET]"
	@echo "Targets:"
	@echo "all		Compiling and linking"
	@echo "objs		Generate objectfiles no linking"
	@echo "exe		Linking to generate executable file"
	@echo "clean		Clean objectfiles and executable"	
	@echo "show		Show varialbes and files"	
	@echo "help		Show this message"
	@echo "project		Generate base project structure"
	@echo "==============================================="

show:
	@echo "============Flags and files============"
	@echo "Source files:		"$(SRC_FILES)
	@echo "object files:		"$(OBJ_FILES)
	@echo "Header files:		"$(HEADER_FILES)
	@echo "include dir:		"$(INCL)
	@echo "Compiler:		"$(CXX)
	@echo "Language standard:	"$(LANG_STD)
	@echo "Error flags:		"$(ERR_FLAGS)
	@echo "Compile flags:		"$(COMPILE)
	@echo "Linker flags:		"$(LINK)
	@echo "libs:			"$(LIBS)
	@echo "======================================="
