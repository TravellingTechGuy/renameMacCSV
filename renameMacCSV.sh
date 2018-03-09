#!/bin/bash

##############################################################################################################
#Written by: Frederick Abeloos | Field Technician | Jamf 
#Created On: March 8th, 2018 / script is provided "AS IS" /

#Purpose: Jamf Pro @enrollment script to rename the mac prior to binding to AD (optional)

#Put this script in a policy with option AFTER (important when using .pkg)

#Upload a pkg in JamfPro which puts an assettag.csv file in /tmp/assettags.csv
#First column serialnumber and second column the desired assettag

#OR use CURL to download any .csv from a public link

# Optional: Create a policy with the directory binding payload and custom trigger 'bindToAD'

##############################################################################################################

### RENAMING SETTINGS ########################################################################################

#Don't change any settings here. Use $4-$9 parameters in Jamf Pro script payload options.

#First choose a naming convention for your Mac.
#Prefix will be set via the $4 parameter in the Jamf Pro policy (script payload).
#Leave the parameter empty if no prefix is required, e.g. type "Mac_" (without the quotes).
prefix="$4"
#Suffix will be set via the $5 parameter in the Jamf Pro policy (script payload).
#Leave the parameter empty if no suffix is required. e.g. type "Mac_" (without the quotes).
suffix="$5"
#Choose serialnumber or assettag via the $6 parameter in the Jamf Pro policy (script payload).
#Set it to "serialnumber" or "assettag" (without the quotes).
namingType="$6"
#Define if you are adding the .pkg with the /tmp/assettags.csv file or using curl to download any .csv file.
#When using curl, the script below will download and rename the file to /tmp/assettags.csv
#Type will be set via $7 paremeter in the Jamf Pro Policy. Type "curl" or "package" (without the quotes).
csvType="$7"
#Define the public link to the .csv file. Leave blank when using .pkg
#Link will be set via th $8 parameter in the Jamf Pro policy. Add the full "https://URL" (without the quotes).
csvURL="$8"
#Path to local csv file, via package in same policy: pkg putting assettags.csv in /tmp/
csvPath="/tmp/assettags.csv"
#Do you want to bind or not? Set to "bind" or leave blank
bindSetting="$9"

### RENAMING SCRIPT ########################################################################################

if [ "$csvType" = "curl" ]; then

	curl -L -o $csvPath $csvURL

fi



if [ "$namingType" = "serialnumber" ]; then

	echo "using serialnumber"
	jamf setComputerName -useSerialNumber -prefix $prefix -suffix $suffix

elif  [ "$namingType" = "assettag" ]; then
 
	echo "using assettag" 
	jamf setComputerName -fromFile "$csvPath" -prefix $prefix -suffix $suffix

fi

### AD BINDING ###########################################################################################

if [ "$bindSetting" = "bind" ]; then

	echo "Binding to AD"

	jamf policy -event bindToAD

else echo "Not binding"

fi


### CLEAN UP #############################################################################################

#delete the assettags.csv

rm "$csvPath"

#update Jamf Pro inventory
jamf recon
