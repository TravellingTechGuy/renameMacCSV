# renameMacCSV
Purpose: Jamf Pro @enrollment script to rename the mac prior to binding to AD (optional)

Script uses the $4 to $9 parameters in the Jamf Pro script policy payload

Requirements:

- add renameMacCSV.sh script in a policy with priority "AFTER" (important when using .pkg)

- create a .csv file with first column serialnumbers and second column the desired asset tags.

- create a .pkg which puts the assettag.csv file in /tmp/assettags.csv and upload it to JamfPro
OR
	use CURL to download any .csv from a public link

- create a policy with trigger @enrollment and add the renameMacCSV.sh in script payload with priority "AFTER" (important when using .pkg). If using .pkg, add the package to the policy.

- set $4 to $9 parameters in the Jamf Pro script policy payload (see below)

- Optional: create a policy with the directory binding payload and custom trigger 'bindToAD'

- scope as required (probably All Computers)

Parameters:

$4 : First choose a naming convention for your Mac.
Prefix will be set via the $4 parameter in the Jamf Pro policy (script payload).
Leave the parameter empty if no prefix is required, e.g. type "Mac_" (without the quotes).

$5 : Suffix will be set via the $5 parameter in the Jamf Pro policy (script payload).
Leave the parameter empty if no suffix is required. e.g. type "Mac_" (without the quotes).

$6 : Choose serialnumber or assettag via the $6 parameter in the Jamf Pro policy (script payload).
Set it to "serialnumber" or "assettag" (without the quotes).

$7 : Define if you are adding the .pkg with the /tmp/assettags.csv file or using curl to download any .csv file.
When using curl, the script below will download and rename the file to /tmp/assettags.csv
Type will be set via $7 parameter in the Jamf Pro Policy. Type "curl" or "package" (without the quotes).

$8 : Define the public link to the .csv file. Leave blank when using .pkg
Link will be set via th $8 parameter in the Jamf Pro policy. Add the full URL (public link).

Hardcoded : Path to local csv file, via package in same policy: pkg putting assettags.csv in /tmp/ (csvPath="/tmp/assettags.csv")

$9 : Do you want to bind to AD or not? Set to "bind" (without the quotes) or leave blank
