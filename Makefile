# Makefile for building a standalone GDAL-plugin for ECW support
#
# (c) 2022 Sven Geggus <sven-git@geggus.net>
#

# Adjust these if you are using another Version of the library
ECWBIN = ECWJP2SDKSetup_5.5.0.2268.bin
ECW_INCLUDE = -I$(HOME)/hexagon/ERDAS-ECW_JPEG_2000_SDK-5.5.0/Desktop_Read-Only/include
ECW_STATIC = $(HOME)/hexagon/ERDAS-ECW_JPEG_2000_SDK-5.5.0/Desktop_Read-Only/lib/cpp11abi/x64/release/libNCSEcw.a
CXXFLAGS	= -g -O2 -fPIC  -Wall $(USER_DEFS)
ECW_FLAGS = -DHAVE_ECW_BUILDNUMBER_H -DLINUX -DX86 -DPOSIX -DHAVE_COMPRESS -DECW_COMPRESS_RW_SDK_VERSION

OBJ = ecwdataset.o ecwcreatecopy.o jp2userbox.o ecwasyncreader.o

GDAL_INCLUDE = /usr/include/gdal
AUTOLOAD_DIR = /usr/lib/gdalplugins/

#CPPFLAGS := $(GDAL_INCLUDE) -DFRMT_ecw $(CPPFLAGS) $(ECW_FLAGS) $(ECW_INCLUDE) $(EXTRA_CFLAGS)

CPPFLAGS := -DFRMT_ecw -I $(GDAL_INCLUDE) $(ECW_FLAGS) $(ECW_INCLUDE) $(EXTRA_CFLAGS)

PLUGIN_SO = gdal_ECW_JP2ECW.so

default: plugin

$(HOME)/hexagon:
	./$(ECWBIN) --accept-eula=YES --install-type=1

clean:
	rm -f *.o $(O_OBJ) *.so
	
mrproper: clean
	rm -rf $(HOME)/hexagon

install-obj:	$(O_OBJ:.o=.$(OBJ_EXT))

install: default
	install -d $(AUTOLOAD_DIR)
	cp $(PLUGIN_SO) $(AUTOLOAD_DIR)

$(OBJ) $(O_OBJ): gdal_ecw.h $(HOME)/hexagon

plugin: $(PLUGIN_SO)

$(PLUGIN_SO): $(OBJ) $(HOME)/hexagon
	g++ -shared -o $(PLUGIN_SO) $(LNK_FLAGS) $(OBJ) $(ECW_STATIC) -lgdal
