#!/bin/bash
exploriztic_dir()
{
	clear
	list=$(ls /mnt/builder/ | grep exploriztic)
	array=($list)
	a=0
	echo "============================"
	echo "Your Exploriztic Directory"
	echo "============================"
	echo
	for item in ${array[*]}
	do
		echo "$a. $item"
		a=$((a+1))
	done
	echo
	echo -en "Choose Exploriztic Directory: "
	read n
	expl_dir="${array[$n]}"
	echo "Your choice is $expl_dir"
	base="/mnt/builder/$expl_dir"
	export base
	exploriztic_builder
}

exploriztic_builder_menu()
{
	clear
	echo
	echo
	echo
	echo
	echo "== Exploriztic Builder=="
	echo "1. Sync New Source from lumbung"
	echo "2. Package Builder"
	echo "3. ISO Builder"
	echo "q. Quit"
	echo -en "What do you want to do : "
}

exploriztic_builder()
{
        i=-1
        while [ "$i" != "q" ]; do
		clear
                exploriztic_builder_menu
                read i
                i=`echo $i | tr '[A-Z]' '[a-z]'`
                case "$i" in
                		"1")
                        sync_package_exploriztic
                        ;;
                        "2")
                        package_builder_exploriztic
                        ;;
                        "3")
                        iso_builder_exploriztic
                        ;;
                        "q")
                        echo "Thank u for using this app"
                        exit 0
                        ;;
                        *)
                        echo "Unrecognised input."
                        ;;
                esac
        done
}

sync_package_exploriztic()
{
	echo
        echo "=============================="
	echo "this menu is under maintenance"
	echo "=============================="
}

package_builder_menu_exploriztic()
{
	clear
        echo
        echo
        echo
        echo
        echo "== Package Builder =="
        echo "1. Release package"
        echo "2. Build Package"
        echo "q. Back"
        echo -en "Enter Your Choice: "
}

package_builder_exploriztic()
{
        i=-1
        while [ "$i" != "q" ]; do
		clear
                package_builder_menu_exploriztic
                read i
                i=`echo $i | tr '[A-Z]' '[a-z]'`
                case "$i" in
                        "1")
                        release_package_exploriztic
                        ;;
                        "2")
                        build_package_exploriztic
                        ;;
                        "q")
                        exploriztic_builder
                        ;;
                        *)
                        echo "Unrecognised input."
                        ;;
                esac
        done
}


release_package_exploriztic()
{
	clear
        ver1=$(cat $base/p_exploriztic_enterprise/exploriztic-enterprise/debian/changelog |tr '()' ' ' | head -1 | awk '{print $2}' | tr '.' ' ' | awk '{print $1}')
        ver2=$(cat $base/p_exploriztic_enterprise/exploriztic-enterprise/debian/changelog |tr '()' ' ' | head -1 | awk '{print $2}' | tr '.' ' ' | awk '{print $2}')
        ver3=$(cat $base/p_exploriztic_enterprise/exploriztic-enterprise/debian/changelog |tr '()' ' ' | head -1 | awk '{print $2}' | tr '.' ' ' | awk '{print $3}')
        verlast=$((ver3+1))
        c_version="$ver1.$ver2.$ver3"
        l_version="$ver1.$ver2.$verlast"
        echo
        echo
        echo
        echo "Your current version is $c_version"
        echo -en "Enter your new version number (default: $l_version): "
        read n
        if [ -z $n ]; then
                echo -en "Enter your Changelog Notes: "
                read c
                sed -i "2i\  * $c" $base/p_exploriztic_enterprise/exploriztic-enterprise/debian/changelog
                sed -i "1s/$c_version/$l_version/g" $base/p_exploriztic_enterprise/exploriztic-enterprise/debian/changelog
        else
                echo -en "Enter your Changelog Notes: "
                read c
                sed -i "2i\  * $c" $base/p_exploriztic_enterprise/exploriztic-enterprise/debian/changelog
                sed -i "1s/$c_version/$n/g" $base/p_exploriztic_enterprise/exploriztic-enterprise/debian/changelog
        fi
        echo "====================="
        echo "done release package"
        echo "====================="

}

build_package_exploriztic()
{
        if [[ -n $l_version ]];then
		clear
                grep_version=$(cat $base/p_exploriztic_enterprise/exploriztic-enterprise/debian/changelog | awk 'NR==1{print $2}' | tr '()' ' ' | tr -d ' ')
                final_version="exploriztic-enterprise_"$grep_version"_amd64.deb"
                cd $base/p_exploriztic_enterprise/exploriztic-enterprise/ && dpkg-buildpackage
                echo "removing previosly exploriztic & Packages.gz file"
                rm $base/exploriztic/cd/pool/extras/exploriztic*
                rm $base/exploriztic/cd/pool/extras/Packages.gz
                echo "copying $final_version to iso directory"
                cp $base/p_exploriztic_enterprise/$final_version $base/exploriztic/cd/pool/extras/
                cd $base/exploriztic/cd/pool/extras/ && dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
                echo "====================================================================================="
                echo "done copy new deb file into local iso repos & done dpkg-scanpackages for new deb file"
                echo "====================================================================================="
        else
                echo "Please Make a Release Package First"
        fi

}

iso_builder_exploriztic()
{
	clear
        i=-1
        while [ "$i" != "q" ]; do
                iso_builder_menu_exploriztic
                read i
                i=`echo $i | tr '[A-Z]' '[a-z]'`
                case "$i" in
                        "1")
                        irmod_uefi_exploriztic
                        ;;
                        "2")
                        irmod_legacy_exploriztic
                        ;;
                        "3")
                        backup_source_exploriztic
                        ;;
                        "4")
                        bungkus_iso_exploriztic
                        ;;
                        "q")
                        exploriztic_builder
                        ;;
                        *)
                        echo "Unrecognised input."
                        ;;
                esac
        done
}

iso_builder_menu_exploriztic()
{
	clear
        echo
        echo
        echo
        echo
        echo "== ISO Builder =="
        echo "1. Build irmod-uefi"
        echo "2. Build irmod-legacy"
        echo "3. Backup Source Directory"
        echo "4. Build ISO"
        echo "q. Back"
        echo -en "Enter your choice: "
}

irmod_uefi_exploriztic()
{
	clear
        echo "entering irmod uefi directory .... "
        cd $base/exploriztic/irmod-uefi/
        echo "Packaging Process ... "
        find . | cpio -H newc --create --verbose | gzip -9 > $base/exploriztic/cd/install.amd/gtk/initrd-uefi.gz
        echo "==============================="
        echo "done packaging irmod-uefi file"
        echo "==============================="
}

irmod_legacy_exploriztic()
{
	clear
        echo "Entering irmod legacy directory .... "
        cd $base/exploriztic/irmod-legacy/
        echo "Packaging Process... "
        find . | cpio -H newc --create --verbose | gzip -9 > $base/exploriztic/cd/install.amd/gtk/initrd-legacy.gz
        echo "================================"
                echo "done packaging irmod-legacy file"
                echo "================================"
}

backup_source_exploriztic()
{
	clear
        version=$(ls $base/exploriztic/cd/pool/extras/ | grep exploriztic | tr '_' ' ' | awk '{print $2}')
        export version
        if [[ -n $version ]];then
		echo
                echo -en "Enter Exploriztic Backup Source Name [Ex: Exploriztic-1.1.0-final ] : " 
                read kodename
                cd $base/exploriztic/ && tar -czvf $base/backup-source/source-$kodename.tar.gz *
                cd $base/p_exploriztic_enterprise/exploriztic-enterprise && tar -czvf $base/backup-source/package-$kodename.tar.gz *
		clear
                echo "=================================================="
                echo "done back up source $kodename"
                echo "=================================================="
        else
                echo "Please Build a Package first before backing up your source"
        fi
}


bungkus_iso_exploriztic()
{
	clear
        ver_list=$(ls $base/p_exploriztic_enterprise | grep deb)
        array=($ver_list)
        a=0
        echo "==========================="
        echo "Exploriztic List Directory"
        echo "==========================="
        echo
        for item in ${array[*]}
        do
                echo "$a. $item"
                a=$((a+1))
        done
        echo
	echo -en "Choose iso name according to the list above: "
        read n
        ver_dir="${array[$n]}"
        echo "Your choice is $ver_dir"
        #### Do Making ISO FILE ####
        ver_dir1=$(echo $ver_dir | grep deb | tr '_' ' ' | awk '{print $1}')
        ver_dir2=$(echo $ver_dir | grep deb | tr '_' ' ' | awk '{print $2}')
        ver_dir_final="$ver_dir1-$ver_dir2"
        cd $base/exploriztic/cd && xorriso -as mkisofs -c isolinux/boot.cat -b isolinux/isolinux.bin -r -J -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -o $ver_dir_final.iso .
        mv $base/exploriztic/cd/$ver_dir_final.iso $base/exploriztic-download/
        echo "====================================================================="
        echo "Done packaging new iso. Please check exploriztic-download Directory"
        echo "====================================================================="
}

