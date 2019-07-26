# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=1
device.name1=OnePlus 5T
device.name2=OnePlus5T
device.name3=oneplus5T
device.name4=dumpling
device.name5=
supported.versions=9
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;


## AnyKernel install
dump_boot;

# begin ramdisk changes

# init.rc
insert_line init.rc "init.simplegx.rc" after "import /init.usb.rc" "import /init.simplegx.rc";
remove_section init.rc "service flash_recovery" ""

# Set the default background app limit to 60
insert_line default.prop "ro.sys.fw.bg_apps_limit=60" before "ro.secure=1" "ro.sys.fw.bg_apps_limit=60";

# Remove suspicious OnePlus services
remove_section init.oem.rc "service OPNetlinkService" "seclabel"
remove_section init.oem.rc "service wifisocket" "seclabel"
remove_section init.oem.rc "service oemsysd" "seclabel"
remove_section init.oem.rc "service oem_audio_device" "oneshot"
remove_section init.oem.rc "service smartadjust" "seclabel"
remove_section init.oem.rc "service atrace" "seclabel"
remove_section init.oem.rc "service sniffer_set" "seclabel"
remove_section init.oem.rc "service sniffer_start" "seclabel"
remove_section init.oem.rc "service sniffer_stop" "seclabel"
remove_section init.oem.rc "service tcpdump-service" "seclabel"
remove_section init.oem.debug.rc "service oemlogkit" "socket oemlogkit"
remove_section init.oem.debug.rc "service dumpstate_log" "seclabel"
remove_section init.oem.debug.rc "service oemasserttip" "disabled"

# end ramdisk changes

write_boot;

## end install

