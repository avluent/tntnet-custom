#project paths
project-dir:=./
bindir:=$(project-dir)bin/
srcdir:=$(project-dir)src/
resources-dir:=$(project-dir)resources/
libdir:=$(resources-dir)lib/
builddir:=$(project-dir)build/
vardir:=$(project-dir)var/

#src paths
cppdir:=$(srcdir)cpp/
cpp-build-dir:=$(builddir)cpp/
ecppdir:=$(srcdir)ecpp/
hdir:=$(srcdir)h/
objdir:=$(builddir)obj/
depsdir:=$(srcdir).deps/
jsdir:=$(srcdir)js/
cssdir:=$(srcdir)css/

#compiler and environment variables
ECPPC=/usr/local/bin/ecppc
LDFLAGS+=-ltntnet -lcxxtools -L$(libdir)
CXXFLAGS+=-Wall -g -o2 -std=c++11
CXX=g++

#virtual paths
vpath %.h $(hdir) $(libdir)
vpath %.cpp $(cppdir) $(cpp-build-dir) $(libdir)
vpath %.ecpp $(ecppdir)
vpath %.o $(objdir)

#application name
appname=calcajax

#automated sources
js-sources:=$(wildcard $(jsdir)*.js)
css-sources:=$(wildcard $(cssdir)*.css)
ecpp-sources:=$(wildcard $(ecppdir)*.ecpp)
cpp-sources:=$(wildcard $(cppdir)*.cpp)

#automated objects
multibin-folders=$(resources-dir)
multibin-folder-basename=$(basename $(patsubst %/,%,$(multibin-folders)))
multibin-objects=$(addsuffix .mb.o,$(multibin-folder-basename))
js-objects=$(notdir $(subst .js,.js.o,$(js-sources)))
css-objects=$(notdir $(subst .css,.css.o,$(css-sources)))
ecpp-objects=$(notdir $(subst .ecpp,.ecpp.o,$(ecpp-sources)))
cpp-objects=$(notdir $(subst .cpp,.cpp.o,$(cpp-sources)))
combined-objects=$(ecpp-objects) $(cpp-objects) $(multibin-objects) $(js-objects) $(css-objects)
main-objects=$(addprefix $(objdir),$(notdir $(combined-objects)))

all:
	@echo "Start building $(appname) application from:\n$(main-objects)"
	@$(MAKE) $(bindir)$(appname) --silent
	@echo "Done building $(appname). It was a great ride, wasn't it?"

#Compile main App
$(bindir)$(appname) : $(main-objects)
	@echo "Compiling main program"
	@$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)
	@echo "Creating symbolic link to executable\n\t==> Done"
	@if [ ! -f $(appname) ]; then ln -s bin/$(appname) && echo "\n\t==> Done"; fi

#Compile from ecpp,js & css to cpp
$(cpp-build-dir)%.ecpp.cpp : $(ecppdir)%.ecpp
	@echo "Compiling $<"
	@$(ECPPC) -o $@ $<
	@echo "\t==> Done"
$(cpp-build-dir)%.js.cpp : $(jsdir)%.js
	@echo "Compiling $<"
	@$(ECPPC) -b -o $@ $<
	@echo "\t==> Done"
$(cpp-build-dir)%.css.cpp : $(cssdir)%.css
	@echo "Compiling $<"
	@$(ECPPC) -b -o $@ $< 
	@echo "\t==> Done"

#Copy from the source cpp to the build cpp folder
$(cpp-build-dir)%.cpp.cpp : $(cppdir)%.cpp
	@echo "Copying $< to the build dir"
	@cp $< $@
	@echo "\t==> Done"

#Compile the Multi-bin cpp files with .d files (included below)
$(cpp-build-dir)resources.mb.cpp : $(shell find $(resources-dir) -type f)
	@echo "Compiling Multi-bin folder resources to CPP File"
	@$(ECPPC) -bb -p -z -n resources -o $(basename $@) $^
	@echo "\t==> Done"

#Compile all cpp to obj before main compilation
$(objdir)%.o : $(cpp-build-dir)%.cpp
	@echo "Compiling $<"
	@$(CXX) $(CXXFLAGS) -c $< -o $@
	@echo "\t==> Done"

.PHONY: spawn clean all debug multibin
.SUFFIXES: ecpp js css

spawn:
	@if [ ! -d $(bindir) ];then echo "Creating directory: $(bindir)" && mkdir $(bindir); fi
	@if [ ! -d $(srcdir) ];then echo "Creating directory: $(srcdir)" && mkdir $(srcdir); fi
	@if [ ! -d $(builddir) ];then echo "Creating directory: $(builddir)" && mkdir $(builddir); fi
	@if [ ! -d $(libdir) ];then echo "Creating directory: $(libdir)" && mkdir $(libdir); fi
	@if [ ! -d $(resources-dir) ];then echo "Creating directory: $(resources-dir)" && mkdir $(resources-dir); fi
	@if [ ! -d $(vardir) ];then echo "Creating directory: $(vardir)" && mkdir $(vardir); fi
	@if [ ! -d $(hdir) ];then echo "Creating directory: $(hdir)" && mkdir $(hdir); fi
	@if [ ! -d $(cppdir) ];then echo "Creating directory: $(cppdir)" && mkdir $(cppdir); fi
	@if [ ! -d $(cpp-build-dir) ];then echo "Creating directory: $(cpp-build-dir)" && mkdir $(cpp-build-dir); fi
	@if [ ! -d $(ecppdir) ];then echo "Creating directory: $(ecppdir)" && mkdir $(ecppdir); fi
	@if [ ! -d $(jsdir) ];then echo "Creating directory: $(jsdir)" && mkdir $(jsdir); fi
	@if [ ! -d $(cssdir) ];then echo "Creating directory: $(cssdir)" && mkdir $(cssdir); fi
	@if [ ! -d $(objdir) ];then echo "Creating directory: $(objdir)" && mkdir $(objdir); fi

multibin:
	@echo "Rebuilding your precious Multibin Files..."
	@if [ "$$(ls -A $(cpp-build-dir))" ];then rm $(cpp-build-dir)*.mb.cpp && echo "Removing old cache files...\n\t==> Done"; fi	
	@$(MAKE) $(bindir)$(appname) --silent
	@echo "Re-creation of Multibin Objects completed."

clean:
	@echo "\nRemoving current program version" 
	@rm $(objdir)*.o $(cpp-build-dir)*.mb.cpp $(appname) $(bindir)$(appname)
	@echo "\t==> Done"
	@echo "\nDone cleaning $(appname).\n"

debug:
	@echo $(mb-folders)
	@echo $(wildcard $(build-cppdir)*.cpp)
	@echo "Main Objects: "$(main-objects)
	@echo $(js-sources) $(css-sources)
	@echo $(main-sources)
	@echo "output: "$(cpp-build-dir)$(notdir src/ecpp/calc.ecpp)
