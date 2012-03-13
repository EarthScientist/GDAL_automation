#!/bin/bash

cd /Data/Base_Data/Climate/AK_CAN_1km_from2km/cccma_cgcm3_1/sresa1b/tas # set the path to the directory of files

# this line instantiates the loop of all of the .tif files in the current directory
for i in *.tif; do

echo "$i" # this echoes the name of the file in loop to the bash terminal

# this line needs changing depending on the shapefile wanting to be used to do the clipping
SHPFILE=/workspace/UA/malindgren/GDAL/akcanada_prism_mask_1km_alfresco_commonextent.shp 

BASE=`basename $SHPFILE .shp` # lets get the shapefile name without the path

# this line will ask ogr's tool ogrinfo to return the extent polygon in the format for GDAL input
EXTENT=`ogrinfo -so $SHPFILE $BASE | grep Extent | sed 's/Extent: //g' | sed 's/(//g' | sed 's/)//g' | sed 's/ - /, /g'`

# this line is similar to above but uses awk to change the list order of the $EXTENT
EXTENT=`echo $EXTENT | awk -F ',' '{print $1 " " $4 " " $3 " " $2}'`
echo "Clipping to $EXTENT" #print command
RASTERFILE=$i # sets the variable in loop to the needed raster file

# here are the gdal commands needed to run the clipping.
gdal_translate -projwin $EXTENT -of GTiff $RASTERFILE /Data/Base_Data/ALFRESCO_formatted/ALFRESCO_Master_Dataset/ALFRESCO_Model_Input_Datasets/AK_CAN_Inputs/Mask_TEMP2/`basename $RASTERFILE .tif`_bbclip.tif
gdalwarp -co COMPRESS=DEFLATE -co TILED=YES -of GTiff -r lanczos -cutline $SHPFILE /Data/Base_Data/ALFRESCO_formatted/ALFRESCO_Master_Dataset/ALFRESCO_Model_Input_Datasets/AK_CAN_Inputs/Mask_TEMP2/`basename $RASTERFILE .tif`_bbclip.tif /Data/Base_Data/ALFRESCO_formatted/ALFRESCO_Master_Dataset/ALFRESCO_Model_Input_Datasets/AK_CAN_Inputs/Mask_TEMP2/`basename $RASTERFILE .tif`_shpclip.tif

done # closes the loop