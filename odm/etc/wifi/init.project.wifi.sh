rf_version=`cat /proc/oplusVersion/RFType`

if [ $rf_version -ge 0 -a $rf_version -le 4 ]; then
    rf_status=0
    echo "rf_status is 0"
else
    if [ $rf_version -eq 7 ]; then
        rf_status=0
        echo "rf_status is 0"
    else
        rf_status=1
        echo "rf_status is 1"
    fi
fi

echo "rf_status=$rf_status rf_version=$rf_version"

if [ ! -s /mnt/vendor/persist/bdwlan.elf ]; then
    if [ $rf_status -eq 1 ]; then
        cp /odm/etc/wifi/bdwlanu.elf /mnt/vendor/persist/bdwlan.elf
        echo "$rf_version" > /mnt/vendor/persist/rf_version
        echo "copy bdwlanu.elf successfully"
    else
        cp /odm/etc/wifi/bdwlan.elf /mnt/vendor/persist/bdwlan.elf
        echo "copy bdwlan.elf successfully"
    fi
    sync
fi

if [ ! -s /mnt/vendor/persist/hardware_debug ] ; then
    persistbdf=`md5sum /mnt/vendor/persist/bdwlan.elf |cut -d" " -f1`
    if [ $rf_status -eq 1 ]; then
        vendorbdf=`md5sum /odm/etc/wifi/bdwlanu.elf |cut -d" " -f1`
    else
        vendorbdf=`md5sum /odm/etc/wifi/bdwlan.elf |cut -d" " -f1`
    fi
    if [ x"$vendorbdf" != x"$persistbdf" ]; then
        if [ $rf_status -eq 1 ]; then
            cp /odm/etc/wifi/bdwlanu.elf /mnt/vendor/persist/bdwlan.elf
            echo "$rf_version" > /mnt/vendor/persist/rf_version
            echo "MD5 copy bdwlanu.elf successfully"
        else
            cp /odm/etc/wifi/bdwlan.elf /mnt/vendor/persist/bdwlan.elf
            echo "MD5 copy bdwlan.elf successfully"
        fi
        sync
        echo "bdf check"
    fi
fi
