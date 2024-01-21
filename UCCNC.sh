#!/bin/bash

export WINEPREFIX=/wine
#export WINEDEBUG=warn+all

if [ ! -f "/wine/drive_c/UCCNC/UCCNC.exe" ]; then
  cd /wine
  setup_filename="setup_1.2115.exe"
  if [ ! -f "/wine/$setup_filename" ]; then
    echo "Try to auto download uccnc installer.."
    wget -O $setup_filename "http://www.cncdrive.com/UCCNC/$setup_filename"

    if [ ! -f "/wine/$setup_filename" ]; then
      echo "ERROR: ./wine/$setup_filename missing! auto download failed too! please put installer file there.."
      exit 1
    fi
  fi

  set -xe
  winetricks sound=pulse
  winetricks corefonts
  winetricks dotnet472

  wine ./$setup_filename
fi

if [ ! -f "/wine/drive_c/UCCNC/UCCNC.exe" ]; then
  echo "ERROR: UCCNC not installed"
  exit 1
else
  cd /wine/drive_c/UCCNC
  if [ -d "/dev/dri" ]; then
    set -ex
    vglrun wine ./UCCNC.exe /p $UCCNC_PROFILE
  else
    set -ex
    LP_NUM_THREADS=1 wine ./UCCNC.exe /p $UCCNC_PROFILE
  fi
fi
