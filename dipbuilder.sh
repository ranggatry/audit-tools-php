#!/bin/bash
#set global variable

#set library
. ./expl_libs.sh

show_menu()
{
	clear
	echo
	echo
	echo
	echo
	echo "== Desktop IP Builder =="
	echo "1. Virtualiztic Builder"
	echo "2. Exploriztic Builder"
	echo "q. Quit"
	echo -en "Enter Your Choice: "
}
do_menu()
{
	clear
        i=-1
        while [ "$i" != "q" ]; do
                show_menu
                read i
                i=`echo $i | tr '[A-Z]' '[a-z]'`
                case "$i" in
                		"1")
                        virtualiztic_dir
                        ;;
                        "2")
                        exploriztic_dir
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

virtualiztic_dir()
{
	clear
	list=$(ls /mnt/builder/ | grep virtualiztic)
	array=($list)
	a=0
	echo "============================"
	echo "Your Virtualiztic Directory"
	echo "============================"
	echo
	for item in ${array[*]}
	do
		echo "$a. $item"
		a=$((a+1))
	done
	echo
	echo -en "Choose Virtualiztic Directory: "
	read n
	virt_dir="${array[$n]}"
	echo "Your choice is $virt_dir"
	base="/mnt/builder/$virt_dir"
	export base
	virtualiztic_builder
}

virtualiztic_builder_menu()
{
	clear
	echo
	echo
	echo
	echo
	echo "== Virtualiztic Builder=="
	echo "1. Sync New Source from lumbung"
	echo "2. Package Builder"
	echo "3. ISO Builder"
	echo "4. Sync Package to Repository"
	echo "q. Quit"
	echo -en "What do you want to do : "
}

virtualiztic_builder()
{
	clear
        i=-1
        while [ "$i" != "q" ]; do
                virtualiztic_builder_menu
                read i
                i=`echo $i | tr '[A-Z]' '[a-z]'`
                case "$i" in
                		"1")
                        sync_package
                        ;;
                        "2")
                        package_builder
                        ;;
                        "3")
                        iso_builder
                        ;;
                        "4")
                        sync_to_repo
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


sync_package_menu()
{
	clear
        echo
        echo
        echo
        echo
        echo "== Package Syncronizer =="
        echo "1. Choose Source to Sync"
        echo "q. Back"
        echo -en "Enter Your Choice: "
}

sync_package()
{
	clear
	i=-1
	while [ "$i" != "q" ]; do
		sync_package_menu
		read i
		i=`echo $i | tr '[A-Z]' '[a-z]'`
		case "$i" in
			"1")
			choose_package
			;;
			"q")
			virtualiztic_builder
			;;
			*)
			echo "Unrecognised input."
			;;
		esac
	done
}

choose_package()
{
	clear
	path=/mnt/builder/lumbung/product-production/virtualiztic
	export path
	list=$(ls /mnt/builder/lumbung/product-production/virtualiztic/ | sort -Vr)
	array=($list)
	a=0
	echo "======================================"
	echo "Your Virtualiztic Directory in Lumbung"
	echo "======================================"
	echo
	for item in ${array[*]}
	do
		echo "$a. $item"
		a=$((a+1))
	done
	echo
	echo -en "Enter Your Choice: "
	read n
	chosen_dir="${array[$n]}"
	echo " Your choice is $chosen_dir"

	cd $path/$chosen_dir 
	cp $path/$chosen_dir/database/virtualiztic.sql $base/p_virtualiztic_enterprise/virtualiztic-enterprise/files/mysql-backup/virtualiztic.sql
	cp $path/$chosen_dir/etc/rc.local $base/p_virtualiztic_enterprise/virtualiztic-enterprise/files/conf/rc.local.template
	rm -R $base/p_virtualiztic_enterprise/virtualiztic-enterprise/files/virtualiztic/*  && sleep 5
	cp $path/$chosen_dir/html/* $base/p_virtualiztic_enterprise/virtualiztic-enterprise/files/virtualiztic/ -R
	cp $path/$chosen_dir/crontabs/root $base/p_virtualiztic_enterprise/virtualiztic-enterprise/files/conf/crontab 
	echo "========================"
	echo "Done syncronizing source"
	echo "========================"
}

package_builder_menu()
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

package_builder()
{
	clear
	i=-1
	while [ "$i" != "q" ]; do
		package_builder_menu
		read i
		i=`echo $i | tr '[A-Z]' '[a-z]'`
		case "$i" in
			"1")
			release_package
			;;
			"2")
			build_package
			;;
			"q")
			virtualiztic_builder
			;;
			*)
			echo "Unrecognised input."
			;;
		esac
	done
}

iso_builder_menu()
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

iso_builder()
{
	clear
	i=-1
	while [ "$i" != "q" ]; do
		iso_builder_menu
		read i
		i=`echo $i | tr '[A-Z]' '[a-z]'`
		case "$i" in
			"1")
			irmod_uefi
			;;
			"2")
			irmod_legacy
			;;
			"3")
			backup_source
			;;
			"4")
			bungkus_iso
			;;
			"q")
			virtualiztic_builder
			;;
			*)
			echo "Unrecognised input."
			;;
		esac
	done
}
dipbuilder.sh

release_package()
{
	clear
	ver1=$(cat $base/p_virtualiztic_enterprise/virtualiztic-enterprise/debian/changelog |tr '()' ' ' | head -1 | awk '{print $2}' | tr '.' ' ' | awk '{print $1}')
	ver2=$(cat $base/p_virtualiztic_enterprise/virtualiztic-enterprise/debian/changelog |tr '()' ' ' | head -1 | awk '{print $2}' | tr '.' ' ' | awk '{print $2}')
	ver3=$(cat $base/p_virtualiztic_enterprise/virtualiztic-enterprise/debian/changelog |tr '()' ' ' | head -1 | awk '{print $2}' | tr '.' ' ' | awk '{print $3}')
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
		echo -en "Enter your Changelog Notes (don't forget to enter date): "
		read c
		sed -i "2i\  * $c" $base/p_virtualiztic_enterprise/virtualiztic-enterprise/debian/changelog
		sed -i "1s/$c_version/$l_version/g" $base/p_virtualiztic_enterprise/virtualiztic-enterprise/debian/changelog
	else 
		echo -en "Enter your Changelog Notes (don't forget to enter date): "
		read c
		sed -i "2i\  * $c" $base/p_virtualiztic_enterprise/virtualiztic-enterprise/debian/changelog
		sed -i "1s/$c_version/$n/g" $base/p_virtualiztic_enterprise/virtualiztic-enterprise/debian/changelog
	fi
	echo "====================="
	echo "done release package"
	echo "====================="

}

build_package()
{
	clear
	if [[ -n $l_version ]];then
		grep_version=$(cat $base/p_virtualiztic_enterprise/virtualiztic-enterprise/debian/changelog | awk 'NR==1{print $2}' | tr '()' ' ' | tr -d ' ')
		final_version="virtualiztic-enterprise_"$grep_version"_amd64.deb"
		cd $base/p_virtualiztic_enterprise/virtualiztic-enterprise/ && dpkg-buildpackage
		echo "removing previosly virtualiztic & Packages.gz file"
		rm $base/virtualiztic-multiboot/cd/pool/extras/virtualiztic*
		rm $base/virtualiztic-multiboot/cd/pool/extras/Packages.gz
		echo "copying $final_version to iso directory"
		cp $base/p_virtualiztic_enterprise/$final_version $base/virtualiztic-multiboot/cd/pool/extras/
		cd $base/virtualiztic-multiboot/cd/pool/extras/ && dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
		echo "====================================================================================="
		echo "done copy new deb file into local iso repos & done dpkg-scanpackages for new deb file"
		echo "====================================================================================="
	else
		echo "Please Make a Release Package First"
	fi
	
}

irmod_uefi()
{
	clear
	echo "masuk irmod uefi directory .... "
	cd $base/virtualiztic-multiboot/irmod-uefi/
	echo "Process pembungkusan... "
	find . | cpio -H newc --create --verbose | gzip -9 > $base/virtualiztic-multiboot/cd/install.amd/gtk/initrd-uefi.gz
	echo "==============================="
	echo "done packaging irmod-uefi file"
	echo "==============================="
}

irmod_legacy()
{
	clear
        echo "masuk irmod legacy directory .... "
        cd $base/virtualiztic-multiboot/irmod-legacy/
        echo "Process pembungkusan... "
        find . | cpio -H newc --create --verbose | gzip -9 > $base/virtualiztic-multiboot/cd/install.amd/gtk/initrd-legacy.gz
        echo "================================"
		echo "done packaging irmod-legacy file"
		echo "================================"
}

backup_source()
{	
	clear
	version=$(ls $base/virtualiztic-multiboot/cd/pool/extras/ | grep virtualiztic | tr '_' ' ' | awk '{print $2}')
	export version
	if [[ -n $version ]];then
		echo
        	echo -en "Enter Virtualiztic Backup Source Name [Ex: Virtualiztic-1.1.0-final ] : "
		read kodename
		cd $base/virtualiztic-multiboot/ && tar -czvf $base/backup-source/source-$kodename.tar.gz *
		cd $base/p_virtualiztic_enterprise/virtualiztic-enterprise && tar -czvf $base/backup-source/package-$kodename.tar.gz *
		echo "======================"
		echo "done backing up source"
		echo "======================"
	else
		echo "Please Build a Package first before backing up your source"
	fi
}

bungkus_iso()
{
	clear
	ver_list=$(ls $base/p_virtualiztic_enterprise | grep deb)
	array=($ver_list)
	a=0
	echo "====================="
	echo "Virtualiztic Version "
	echo "====================="
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
	cd $base/virtualiztic-multiboot/cd && xorriso -as mkisofs -c isolinux/boot.cat -b isolinux/isolinux.bin -r -J -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -o $ver_dir_final.iso .	
	mv $base/virtualiztic-multiboot/cd/$ver_dir_final.iso $base/virtualiztic-download/
	echo "====================================================================="
	echo "Done packaging new iso. Please check virtualiztic-download Directory"
	echo "====================================================================="
}


sync_to_repo()
{
	clear
	echo "Syncing new package into repository .... "
	mkdir -p /mnt/builder/repository-dir/package-virtualiztic &&
	rsync --exclude='Packages.gz' -avzhp $base/virtualiztic-multiboot/cd/pool/extras/*  /mnt/builder/repository-dir/package-virtualiztic
	cd /mnt/builder/repository-dir/package-virtualiztic &&
	reprepro -b /mnt/builder/repository-dir includedeb virtualiztic *
	echo "Process pembungkusan... "
	echo "==============================="
	echo "done syncing package"
	echo "==============================="
}


do_menu
