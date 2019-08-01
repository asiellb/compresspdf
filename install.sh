#!/bin/bash
#Definitions
dst=/usr/local/bin/compresspdf
tmpdst=/private/tmp/compresspdf
#Functions
install() {
    cp -rf $tmpdst $dst
    chmod +x $dst
}
#Main
which compresspdf > /dev/null
curl -L https://git.io/fj9mu -o $tmpdst -s > /dev/null
if [[ $? -eq 1 ]]; then
    echo -e "\033[1minfo >>> \033[0m Running compresspdf installation..."
    install
    echo -e "\033[1minfo >>> \033[0m Installation successfull! \n
    For help use \033[1mcompresspdf -h\033[0m \n "
else
    if cmp $tmpdst $dst > /dev/null; then
        echo -e "\033[1minfo >>> \033[0mcompresspdf already installed on your system and up to date! \n
        For help use \033[1mcompresspdf -h\033[0m \n "
    else
        echo -e "\033[1minfo >>> \033[0m Updating compresspdf installation..."
        install
        echo -e "\033[1minfo >>> \033[0m Update successfull! \n
        For help use \033[1mcompresspdf -h\033[0m \n "
    fi
    rm -rf $tmpdst
fi
exit 0




