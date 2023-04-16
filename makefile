BIN = bin
BUILD = build
SRC_DIR = src
DEP_DIR = $(BUILD)/dep
OBJ_DIR = $(BUILD)/objs
##add additional includes if needed ex. /path/to/include/
INCL_DIR = include/ D:\Code\SFML\SFML-2.5.1-gcc\include/
INCL = $(addprefix -I,$(INCL_DIR))
EXE = lab_.exe

VPATH := $(SRC_DIR)

PROJECT_STRUCTURE = $(BIN)/. $(BUILD)/. $(OBJ_DIR)/. $(DEP_DIR)/. $(SRC_DIR)/. $(INCL_DIR)/.

SRC_FILES = $(wildcard $(SRC_DIR)/*.cpp)
HEADER_FILES = $(wildcard $(INCL_DIR)/*.hpp)
OBJ_FILES = $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(SRC_FILES))
##list of dep files with new file path to dep dir
DEP_FILES = $(OBJ_FILES:$(OBJ_DIR)/%.o=$(DEP_DIR)/%.d)
##add additional libraries if needed ex. -L./path/to/lib/
LIBDIRS = -LD:\Code\SFML\SFML-2.5.1-gcc\lib
##Specify libs to use ex. -lsfml-graphics
LIBS = -lsfml-graphics -lsfml-window -lsfml-system -lsfml-audio
##Compiler
CXX = g++
LANG_STD = -std=c++17
ERR_FLAGS = -Wall -Wpedantic -Werror
## generate dep with phony targets and output to bin/dep
DEP_GEN = -MMD -MP -MF $(DEP_DIR)/$*.d

##Linker flags
#LDFLAGS = $(addprefix -L,$(LIBDIRS)) $(LIBS)
LDFLAGS = $(LIBDIRS) 
#Compiler flags
CXXFLAGS = $(LANG_STD) $(ERR_FLAGS)
##Preprocessor flags and includepath
CPPFLAGS = $(INCL)
COMPILE = $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(DEP_GEN) -c
LINK = $(CXX) $(LDFLAGS)

.PHONY: all
all: $(BIN)/$(EXE)

debug: CXXFLAGS += -g
.PHONY: debug
debug: $(BIN)/$(EXE)

##Generating base directory structure for project
##and main file
##----------------------------------------------------------
.PHONY: project
project: $(PROJECT_STRUCTURE) $(SRC_DIR)/main.cpp
$(PROJECT_STRUCTURE):
	mkdir -p $@
$(SRC_DIR)/main.cpp: 
	[ -f $(SRC_DIR)/main.cpp ] || echo -e '#include <iostream>\n\nint main(int argc, char* argv[])\n{\n\n\tstd::cout << "Hello world!\\n";\n\n\treturn 0;\n}\n' > $(SRC_DIR)/main.cpp

.SECONDEXPANSION:

##Rule for generating the executable.
##----------------------------------------------------------
.PHONY: exe
exe: $(BIN)/$(EXE) $(PROJECT_STRUCTURE)
$(BIN)/$(EXE): $(OBJ_FILES) | $$(@D)/.
	$(LINK) $(OBJ_FILES) $(LIBS) -o $@

##Rule for compiling and generatign objectfiles (.o) files.
##----------------------------------------------------------
.PHONY: objs
objs:$(OBJ_FILES) $(PROJECT_STRUCTURE)
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $$(@D)/.
	$(COMPILE) $< -o $@

-include $(DEP_FILES)

##Running the program
##----------------------------------------------------------
.PHONY: run
run: exe
	./$(BIN)/$(EXE)

##Clean up the executable and object files
##----------------------------------------------------------
.PHONY: clean
clean:
	rm -rf $(OBJ_FILES) $(BIN)/$(EXE)

.PHONY: help
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
	@echo "run		run the project"
	@echo "==============================================="

.PHONY: show
show:
	@echo "============Flags and files============"
	@echo "EXE:			"$(BIN)/$(EXE)
	@echo "Source files:		"$(SRC_FILES)
	@echo "object files:		"$(OBJ_FILES)
	@echo "Header files:		"$(HEADER_FILES)
	@echo "include dir:		"$(INCL)
	@echo "dependency files:	"$(DEP_FILES)
	@echo "Compiler:		"$(CXX)
	@echo "Language standard:	"$(LANG_STD)
	@echo "Error flags:		"$(ERR_FLAGS)
	@echo "Compile flags:		"$(COMPILE)
	@echo "Linker flags:		"$(LINK)
	@echo "libs:			"$(LIBS)
	@echo "======================================="
