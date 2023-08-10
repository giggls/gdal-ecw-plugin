# Most simple ECW support for gdal on Debian 11 (bullseye)

Hugely based on https://github.com/interob/libgdal-ecw

## Rationale

GIS people usually do not care about the formats they are using but they
tend to care about storage space. For this reason customers often supply
their data in compressed form.

Unfortunately this often means that they use the patented and proprietary
ECW-format.

## To the recue

Hexagon Geospatial provides a proprietary library for reading ECW files:
http://download.hexagongeospatial.com/downloads/ecw/erdas-ecw-jp2-sdk-v5-5-update-4-linux

This said all you usually need in the world of FOSS GIS Software is support
in [GDAL](https://gdal.org/) thus this code will build a single self-sufficient
Plugin for GDAL using the proprietary ECW library which can be copied to /usr/lib/gdalplugins/
on Debian/Ubuntu based distributions.

## Installation

1. Install ``libgdal-dev`` package.
2. Clone this repository:
   ``git clone https://github.com/giggls/gdal-ecw-plugin``
3. Download and extract ``ECWJP2SDKSetup_5.5.0.2268-Update4-Linux.zip``. This
   will give you ``ECWJP2SDKSetup_5.5.0.2268.bin``
4. Put this file into the cloned directory and run
5. Call ``make`` which will give you a file called ``gdal_ECW_JP2ECW.so``
6. Copy ``gdal_ECW_JP2ECW.so`` into /usr/lib/x86_64-linux-gnu/gdalplugins or call
   ``sudo make install``.
7. Optionally call ``make mrproper`` which will remove the ``hexagon``
   folder from your home directory.

To check if this worked properly call ``gdalinfo --formats`` command which should
give you something like this:

```
 ~/ > gdalinfo --formats |grep -i ECW
  ECW -raster- (rw+): ERDAS Compressed Wavelets (SDK 5.5)
  JP2ECW -raster,vector- (rw+v): ERDAS JPEG2000 (SDK 5.5)
```
