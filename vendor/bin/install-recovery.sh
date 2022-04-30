#!/vendor/bin/sh
if ! applypatch --check EMMC:/dev/block/bootdevice/by-name/recovery:134217728:21bb935753c6e2c25ccc3d17ab11f554b8291f56; then
  applypatch  \
          --patch /vendor/recovery-from-boot.p \
          --source EMMC:/dev/block/bootdevice/by-name/boot:100663296:8fb73e645fa03983dc3b55681a2f1c75fddda5fd \
          --target EMMC:/dev/block/bootdevice/by-name/recovery:134217728:21bb935753c6e2c25ccc3d17ab11f554b8291f56 && \
      log -t recovery "Installing new oplus recovery image: succeeded" && \
      setprop ro.boot.recovery.updated true || \
      log -t recovery "Installing new oplus recovery image: failed" && \
      setprop ro.boot.recovery.updated false
else
  log -t recovery "Recovery image already installed"
  setprop ro.boot.recovery.updated true
fi
