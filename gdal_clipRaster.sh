#!/bin/bash
SHPFILE=$1 # the shapefile variable
BASE=`basename $SHPFILE .shp` # lets get the shapefile name without the path
EXTENT=`ogrinfo -so $SHPFILE $BASE | grep Extent | sed 's/Extent: //g' | sed 's/(//g' | sed 's/)//g' | sed 's/ - /, /g'`
EXTENT=`echo $EXTENT | awk -F ',' '{print $1 " " $4 " " $3 " " $2}'`
echo "Clipping to $EXTENT"
RASTERFILE=$2
gdal_translate -projwin $EXTENT -of GTiff $RASTERFILE /tmp/`basename $RASTERFILE .tif`_bbclip.tif
gdalwarp -co COMPRESS=DEFLATE -co TILED=YES -of GTiff \
-r lanczos -cutline $SHPFILE \
/tmp/`basename $RASTERFILE .tif`_bbclip.tif /tmp/`basename $RASTERFILE .tif`_shpclip.tif