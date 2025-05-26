#!/bin/bash
SCRIPT_PATH=${0}
SCRIPT_DIR=`dirname ${0}`
SCRIPT_NAME=`basename ${0}`
WORKING_DIR=`pwd`


echo "Uninstalling Maxon App v2024.5.0"

"/Library/Application Support/Red Giant/Services/rguninstaller" command=uninstall identifier=net.maxon.app-manager version=2024.5.0

echo "Uninstalling com.redgiant.uninstaller v1.0.0"

"/Library/Application Support/Red Giant/Services/rguninstaller" command=uninstall identifier=com.redgiant.uninstaller version=1.0.0

