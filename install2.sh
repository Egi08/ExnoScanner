#!/bin/bash

# ANSI color code variables
declare -A colors=(
    [red]="\e[0;91m"
    [blue]="\e[0;94m"
    [yellow]="\e[0;33m"
    [green]="\e[0;92m"
    [cyan]="\e[0;36m"
    [uline]="\e[0;35m"
    [reset]="\e[0m"
)

# Tool installation function
install_tools() {
    echo -e "${colors[yellow]}[+] Installing required tools...${colors[reset]}"

    # Install essential packages
    sudo apt-get update
    sudo apt-get install -y golang-go cmake whatweb ffuf sqlmap unzip

    # Install Go-based tools
    echo -e "${colors[yellow]}[+] Installing Go-based tools...${colors[reset]}"
    go install github.com/hahwul/dalfox/v2@latest
    go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
    go install github.com/projectdiscovery/httpx/cmd/httpx@latest
    go install github.com/lc/gau@latest
    go install github.com/tomnomnom/gf@latest
    go install github.com/tomnomnom/qsreplace@latest
    go install github.com/tomnomnom/anew@latest
    go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
    go install github.com/projectdiscovery/katana/cmd/katana@latest

    # Install Subzy (updated URL)
    echo -e "${colors[yellow]}[+] Installing Subzy...${colors[reset]}"
    wget https://github.com/lukasikic/subzy/releases/download/v1.2.1/subzy_1.2.1_linux_amd64.zip
    if [[ -f "subzy_1.2.1_linux_amd64.zip" ]]; then
        unzip subzy_1.2.1_linux_amd64.zip
        sudo mv subzy /usr/local/bin/
    else
        echo -e "${colors[red]}[!] Failed to download Subzy. Check the URL or network connection.${colors[reset]}"
    fi

    # Move binaries to /usr/local/bin
    sudo mv "$HOME/go/bin/dalfox" /usr/local/bin/
    sudo mv "$HOME/go/bin/subfinder" /usr/local/bin/
    sudo mv "$HOME/go/bin/httpx" /usr/local/bin/
    sudo mv "$HOME/go/bin/gau" /usr/local/bin/
    sudo mv "$HOME/go/bin/gf" /usr/local/bin/
    sudo mv "$HOME/go/bin/qsreplace" /usr/local/bin/
    sudo mv "$HOME/go/bin/anew" /usr/local/bin/
    sudo mv "$HOME/go/bin/nuclei" /usr/local/bin/
    sudo mv "$HOME/go/bin/katana" /usr/local/bin/

    # Install Python-based tools
    echo -e "${colors[yellow]}[+] Installing Python-based tools...${colors[reset]}"
    sudo pip3 install uro pystyle --root-user-action=ignore
    if [[ -f "$HOME/.local/bin/uro" ]]; then
        sudo mv "$HOME/.local/bin/uro" /usr/local/bin/
    else
        echo -e "${colors[red]}[!] 'uro' binary not found in ~/.local/bin/. Check installation.${colors[reset]}"
    fi

    # Install ParamSpider
    echo -e "${colors[yellow]}[+] Installing ParamSpider...${colors[reset]}"
    sudo pip3 install git+https://github.com/devanshbatham/ParamSpider.git --root-user-action=ignore
}

# Main script execution
echo -e "${colors[yellow]}##########################################################"
echo -e "##### Welcome to the ExnoScanner installation script #####"
echo -e "##########################################################${colors[reset]}"

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo -e "${colors[red]}[!] This script must be run as root. Please run with sudo.${colors[reset]}"
    exit 1
fi

# Create the ExnoScanner directory
echo -e "${colors[blue]}[+] Creating the ExnoScanner directory...${colors[reset]}"
mkdir -p "$HOME/exnoscan"
cd "$HOME/exnoscan" || exit

install_tools
echo -e "${colors[green]}[+] ExnoScanner installation completed!${colors[reset]}"
