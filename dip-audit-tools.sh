#!/bin/bash

show_menu()
{
	clear
	echo
	echo
	echo
	echo
	echo "== Desktop IP Auditing Tools =="
	echo "1. Deploy Tools"
	echo "2. Mess Detector "
	echo "3. Code Sniffer "
	echo "4. Code Fixer "
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
                        deploy_tools
                        ;;
                		"2")
                        mess_detector
                        ;;
                        "3")
                        code_sniffer
                        ;;
						"4")
                        code_fixer
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
deploy_tools()
{
	clear
	###deploy phpmd
	cp /etc/apt/sources.list /etc/apt/sources.list.old
	echo "deb http://ftp.de.debian.org/debian jessie main" > /etc/apt/sources.list
	apt-get update && apt-get install phpmd -y
	cp /etc/apt/sources.list.old /etc/apt/sources.list

	###deploy phpcs
	wget https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
	wget https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar
	mv phpcs.phar phpcs
	mv phpcbf.phar phpcbf
	chmod +x phpcs
	chmod +x phpcbf


	### install composer
	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
	php -r "if (hash_file('sha384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
	php composer-setup.php
	php -r "unlink('composer-setup.php');"
	mv composer.phar composer
	chmod +x composer
	./composer global require "squizlabs/php_codesniffer=*"

	###install pylint
	cp /etc/apt/sources.list /etc/apt/sources.list.old
	echo "deb http://ftp.de.debian.org/debian jessie main" > /etc/apt/sources.list
	apt-get update && apt-get install pylint -y
	cp /etc/apt/sources.list.old /etc/apt/sources.list

	### install autopep8
	pip install --upgrade autopep8

	echo "==============================="
	echo "done deploying tools"
	echo "==============================="

}
mess_detector()
{
	clear
        i=-1
        while [ "$i" != "q" ]; do
                mess_detector_menu
                read i
                i=`echo $i | tr '[A-Z]' '[a-z]'`
                case "$i" in
                		"1")
                        php_mess_detector
                        ;;
                        "q")
						do_menu
						;;
						*)
                        echo "Unrecognised input."
                        ;;
                esac
        done
}
mess_detector_menu()
{
	echo
	echo
	echo
	echo
	echo "== Mess Detector Menu=="
	echo "1. PHP Mess Detector"
	echo "q. Quit"
	echo -en "What do you want to do : "
}

php_mess_detector()
{
	clear
	echo "== PHP Mess Detector =="
	echo -en "Enter your php path directory (example: /var/www/html/): "
	read n
	phpmd $n text codesize
	echo "==============================="
	echo "done php mess detector process"
	echo "==============================="

}

code_sniffer()
{
	clear
        i=-1
        while [ "$i" != "q" ]; do
                code_sniffer_menu
                read i
                i=`echo $i | tr '[A-Z]' '[a-z]'`
                case "$i" in
                		"1")
                        php_code_sniffer
                        ;;
                        "2")
                        python_code_sniffer
                        ;;
                        "q")
						do_menu
						;;
						*)
                        echo "Unrecognised input."
                        ;;
                esac
        done
}

code_sniffer_menu()
{ 
	
	echo
	echo
	echo
	echo
	echo "== Code Sniffer Menu =="
	echo "1. PHP Code Sniffer"
	echo "2. Python"
	echo "q. Quit"
	echo -en "What do you want to do : "
}
php_code_sniffer()
{
	clear
	echo "== PHP Code Sniffer =="
	echo -en "Enter your php path files (example: /var/www/html/index.php): "
	read n
	./phpcs $n
	echo "==============================="
	echo "done php code sniffer process"
	echo "==============================="

}
python_code_sniffer()
{
	clear
	echo "== Python Code Sniffer =="
	echo -en "Enter your python path files (example: /var/www/html/index.py): "
	read n
	pylint $n
	echo "==============================="
	echo "done python code sniffer process"
	echo "==============================="

}

code_fixer()
{
	clear
        i=-1
        while [ "$i" != "q" ]; do
                code_fixer_menu
                read i
                i=`echo $i | tr '[A-Z]' '[a-z]'`
                case "$i" in
                		"1")
                        php_code_fixer
                        ;;
                        "2")
                        python_code_fixer
                        ;;
                        "q")
						do_menu
						;;
						*)
                        echo "Unrecognised input."
                        ;;
                esac
        done
}
code_fixer_menu()
{
	
	echo
	echo
	echo
	echo
	echo "== Code Fixer Menu=="
	echo "1. PHP Code Fixer"
	echo "2. Python Code Fixer"
	echo "q. Quit"
	echo -en "What do you want to do : "
}
php_code_fixer()
{
	clear
	echo "== PHP Code Fixer=="
	echo -en "Enter your php path files (example: /var/www/html/index.php): "
	read n
	./phpcbf $n
	echo "==============================="
	echo "done php code fixer process"
	echo "==============================="

}
python_code_fixer()
{
	clear
	echo "== Python Code Fixer =="
	echo -en "Enter your python path files (example: /var/www/html/index.py): "
	read n
	autopep8 --in-place --aggressive --aggressive  $n
	echo "==============================="
	echo "done python code fixer process"
	echo "==============================="

}

do_menu
