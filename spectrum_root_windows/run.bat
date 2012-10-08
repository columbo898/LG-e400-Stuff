::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::  LG Spectrum root script
::  Windows version
::
::  Copyright (C) 2012 Dan Rosenberg (@djrbliss)
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
:: Instructions:
::
::  1. Ensure you have the latest drivers installed from LG
::
::  2. Put your device in debugging mode
::
::  3. Attach it via USB
::
::  4. Run this script in the same directory as the rest of the extracted
::     zipfile
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

@echo off
cd "%~dp0"

echo [*]
echo [*] LG Spectrum Root Exploit (Windows version)
echo [*] by Dan Rosenberg (@djrbliss)
echo [*]
echo [*] Before continuing, ensure USB debugging is enabled, that you
echo [*] have the latest LG drivers installed, and that your tablet
echo [*] is connected via USB.
echo [*]
echo [*] Press enter to root your phone...
pause
echo [*] 

echo [*] Waiting for device...
adb wait-for-device

echo [*] Device found.

adb shell "rm /data/gpscfg/gps_env.conf 2>/dev/null"
adb shell "ln -s /data /data/gpscfg/gps_env.conf"

echo [*] Rebooting device...
adb reboot
echo [*] Waiting for device to reboot...
adb wait-for-device

adb shell "echo 'ro.kernel.qemu=1' > /data/local.prop"
echo [*] Rebooting device again...
adb reboot
echo [*] Waiting for device to reboot...
adb wait-for-device

echo [*] Attemping persistence...
adb remount
adb push su /system/bin/su
adb shell "chmod 6755 /system/bin/su"
adb shell "ln -s /system/bin/su /system/xbin/su"
adb push busybox /system/xbin/busybox
adb shell "chmod 755 /system/xbin/busybox"
adb shell "/system/xbin/busybox --install /system/xbin"
adb push Superuser.apk /system/app/Superuser.apk

echo [*] Cleaning up...
adb shell "rm /data/local.prop"
adb shell "rm /data/gpscfg/*"
adb shell "chmod 771 /data/"

echo [*] Rebooting...
adb reboot
adb wait-for-device

echo [*] Exploit complete!
echo [*] Press any key to exit.
pause
adb kill-server
