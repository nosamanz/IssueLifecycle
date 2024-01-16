#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

install() {
    echo -e "${GREEN}Installing Issue Lifecycle plugin${NC}"
    cp -r issue_lifecycle ../plugins/
    mkdir -p ../public/plugin_assets/issue_lifecycle
    cp -r assets/* ../public/plugin_assets/issue_lifecycle/
    echo -e "${GREEN}Installation complete.${NC}"
    echo -e "${GREEN}You can delete this installation file.${NC}"
}

uninstall() {
    read -p "Are you sure you want to remove the plugin? (Y/N): " confirm
    if [ "$confirm" == "Y" ] || [ "$confirm" == "y" ]; then
        rm -r ../plugins/issue_lifecycle
        rm -r ../public/plugin_assets/issue_lifecycle
        echo -e "${GREEN}The plugin was removed.${NC}"
    else
        echo -e "${RED}Process canceled.${NC}"
    fi
}
if [ "$1" == "install" ]; then
    install
elif [ "$1" == "uninstall" ]; then
    uninstall
else
    echo -e "${RED}Usage: $0 install|uninstall${NC}"
    exit 1
fi
