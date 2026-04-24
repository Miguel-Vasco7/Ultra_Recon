#!/bin/bash

# Script de instalação das dependências para o ULTRA RECON
# Autor: Miguel Vasco

# --- CORES ---
VERDE='\033[1;32m'
AMARELO='\033[1;33m'
VERMELHO='\033[1;31m'
AZUL='\033[1;34m'
ROSA='\033[35;1m'
BRANCO='\033[1;37m'
RESET='\033[0m'

# --- FUNÇÕES ---
logo() {
    clear
    echo -e "${ROSA}#------------------------------------------------------------#${RESET}"
    echo -e " ${BRANCO} ULTRA RECON - INSTALADOR DE DEPENDÊNCIAS${RESET}"
    echo -e " ${ROSA} Miguel Vasco | Backend Developer & Web Pentester ${RESET}"
    echo -e "${ROSA}#------------------------------------------------------------#${RESET}"
    echo ""
}

msg() {
    echo -e "${VERDE}[+]${RESET} ${BRANCO}$1${RESET}"
}

erro() {
    echo -e "${VERMELHO}[!] ERRO:${RESET} ${BRANCO}$1${RESET}"
}

aviso() {
    echo -e "${AMARELO}[!]${RESET} ${BRANCO}$1${RESET}"
}

check_command() {
    command -v $1 >/dev/null 2>&1
}

install_go() {
    msg "Instalando Go..."
    
    if [ -f /etc/debian_version ]; then
        sudo apt update
        sudo apt install -y golang-go
    elif [ -f /etc/redhat-release ]; then
        sudo yum install -y golang
    elif [ -f /etc/arch-release ]; then
        sudo pacman -S --noconfirm go
    elif [ "$(uname)" == "Darwin" ]; then
        brew install go
    else
        # Instalação manual
        wget https://go.dev/dl/go1.22.0.linux-amd64.tar.gz
        sudo tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz
        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
        echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
        source ~/.bashrc
        rm go1.22.0.linux-amd64.tar.gz
    fi
}

install_python_deps() {
    msg "Instalando dependências Python..."
    
    # Instala pip se não existir
    if ! check_command pip3; then
        sudo apt install -y python3-pip || sudo yum install -y python3-pip
    fi
    
    # Instala ferramentas Python
    pip3 install --upgrade pip
    
    # Instala ferramentas específicas
    sudo pip3 install uro
    sudo pip3 install arjun
    sudo pip3 install waybackpy
    sudo pip3 install gf
    
    # Instala nuclei se disponível via pip
    sudo pip3 install nuclei-py 2>/dev/null || true
}

install_tools_go() {
    msg "Instalando ferramentas Go..."
    
    # Define GOPATH se não estiver definido
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH/bin
    
    # Lista de ferramentas Go para instalar
    tools=(
        "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
        "github.com/projectdiscovery/httpx/cmd/httpx@latest"
        "github.com/projectdiscovery/katana/cmd/katana@latest"
        "github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest"
        "github.com/tomnomnom/waybackurls@latest"
        "github.com/lc/gau/v2/cmd/gau@latest"
        "github.com/projectdiscovery/shuffledns/cmd/shuffledns@latest"
        "github.com/projectdiscovery/dnsx/cmd/dnsx@latest"
        "github.com/projectdiscovery/naabu/v2/cmd/naabu@latest"
    )
    
    for tool in "${tools[@]}"; do
        tool_name=$(echo $tool | awk -F'/' '{print $NF}' | cut -d'@' -f1)
        msg "Instalando $tool_name..."
        go install $tool 2>/dev/null || aviso "Falha ao instalar $tool_name"
    done
}

install_apt_tools() {
    msg "Instalando ferramentas via apt..."
    
    # Atualiza repositórios
    sudo apt update
    
    # Lista de ferramentas
    tools=(
        "jq"
        "curl"
        "wget"
        "git"
        "unzip"
        "make"
        "gcc"
        "libpcap-dev"
        "dnsutils"
        "nmap"
        "sqlmap"
        "dirb"
        "gobuster"
        "nikto"
        "whatweb"
        "dnsenum"
        "sslscan"
        "testssl.sh"
    )
    
    for tool in "${tools[@]}"; do
        if ! check_command $tool; then
            sudo apt install -y $tool 2>/dev/null || aviso "Não foi possível instalar $tool"
        fi
    done
}

install_yum_tools() {
    msg "Instalando ferramentas via yum..."
    
    tools=(
        "jq"
        "curl"
        "wget"
        "git"
        "unzip"
        "make"
        "gcc"
        "libpcap-devel"
        "bind-utils"
        "nmap"
        "epel-release"
    )
    
    for tool in "${tools[@]}"; do
        if ! check_command $tool; then
            sudo yum install -y $tool 2>/dev/null || aviso "Não foi possível instalar $tool"
        fi
    done
}

install_brew_tools() {
    msg "Instalando ferramentas via Homebrew (macOS)..."
    
    tools=(
        "jq"
        "curl"
        "wget"
        "git"
        "nmap"
        "go"
        "libpcap"
        "bind"
    )
    
    for tool in "${tools[@]}"; do
        if ! check_command $tool; then
            brew install $tool 2>/dev/null || aviso "Não foi possível instalar $tool"
        fi
    done
}

install_nuclei_templates() {
    msg "Atualizando templates do Nuclei..."
    
    if check_command nuclei; then
        nuclei -update-templates -silent
    else
        # Instala nuclei se não estiver instalado
        go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
        nuclei -update-templates -silent
    fi
}

install_arjun() {
    msg "Instalando Arjun..."
    
    # Tenta instalar via pip
    pip3 install arjun 2>/dev/null || true
    
    # Se não funcionar, tenta via git
    if ! check_command arjun; then
        git clone https://github.com/s0md3v/Arjun.git /tmp/arjun
        cd /tmp/arjun
        sudo python3 setup.py install
        cd -
    fi
}

install_js_tools() {
    msg "Instalando ferramentas JS..."
    
    # Node.js e npm
    if ! check_command node; then
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        sudo apt install -y nodejs
    fi
    
    # Ferramentas JS
    if check_command npm; then
        sudo npm install -g js-beautify
    fi
}

install_gf_patterns() {
    msg "Instalando padrões GF..."
    
    if check_command gf; then
        mkdir -p ~/.gf
        git clone https://github.com/1ndianl33t/Gf-Patterns.git /tmp/gf-patterns
        cp -r /tmp/gf-patterns/* ~/.gf/
    else
        aviso "GF não instalado. Instale com: pip3 install gf"
    fi
}

setup_environment() {
    msg "Configurando ambiente..."
    
    # Adiciona Go ao PATH se necessário
    if [ -d "$HOME/go/bin" ] && [[ ":$PATH:" != *":$HOME/go/bin:"* ]]; then
        echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.bashrc
        echo 'export GOPATH=$HOME/go' >> ~/.bashrc
    fi
    
    # Para zsh
    if [ -f ~/.zshrc ]; then
        if [ -d "$HOME/go/bin" ] && ! grep -q "go/bin" ~/.zshrc; then
            echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.zshrc
            echo 'export GOPATH=$HOME/go' >> ~/.zshrc
        fi
    fi
    
    source ~/.bashrc 2>/dev/null || true
}

verify_installations() {
    msg "Verificando instalações..."
    
    echo -e "\n${AZUL}=== FERRAMENTAS INSTALADAS ===${RESET}"
    
    declare -A tools=(
        ["subfinder"]="Subfinder"
        ["httpx"]="HTTPX"
        ["katana"]="Katana"
        ["nuclei"]="Nuclei"
        ["gau"]="GAU"
        ["waybackurls"]="Waybackurls"
        ["arjun"]="Arjun"
        ["uro"]="URO"
        ["jq"]="jq"
        ["curl"]="cURL"
        ["gf"]="GF"
    )
    
    for cmd in "${!tools[@]}"; do
        if check_command $cmd; then
            echo -e "${VERDE}[✓]${RESET} ${tools[$cmd]}"
        else
            echo -e "${VERMELHO}[✗]${RESET} ${tools[$cmd]}"
        fi
    done
}

create_test_script() {
    msg "Criando script de teste..."
    
    cat > test_dependencies.sh << 'EOF'
#!/bin/bash

echo "=== TESTANDO DEPENDÊNCIAS DO ULTRA RECON ==="
echo ""

# Testa cada comando
commands=("subfinder" "httpx" "katana" "nuclei" "gau" "waybackurls" "arjun" "jq" "curl" "gf")

for cmd in "${commands[@]}"; do
    if command -v $cmd &> /dev/null; then
        version=$($cmd --version 2>/dev/null || $cmd -version 2>/dev/null || echo "comando disponível")
        echo "✓ $cmd: $version"
    else
        echo "✗ $cmd: NÃO INSTALADO"
    fi
done

echo ""
echo "=== CONFIGURAÇÃO DO GO ==="
echo "GOPATH: $GOPATH"
echo "GO BIN: $(which go)"
echo "PATH contém Go: $(echo $PATH | grep -o go)"

EOF
    
    chmod +x test_dependencies.sh
    msg "Script de teste criado: ./test_dependencies.sh"
}

main() {
    logo
    
    echo -e "${BRANCO}Este script instalará todas as dependências do ULTRA RECON.${RESET}"
    echo -e "${AMARELO}Nota: Você precisará de privilégios sudo para algumas instalações.${RESET}"
    echo ""
    read -p "Continuar? (s/n): " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        echo "Instalação cancelada."
        exit 0
    fi
    
    # Detecta sistema operacional
    OS=""
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    elif [ "$(uname)" == "Darwin" ]; then
        OS="macos"
    fi
    
    msg "Sistema detectado: $OS"
    
    # Instala dependências básicas
    case $OS in
        ubuntu|debian|kali|parrot)
            install_apt_tools
            ;;
        centos|fedora|rhel)
            install_yum_tools
            ;;
        macos)
            install_brew_tools
            ;;
        *)
            aviso "Sistema não suportado. Instalação manual necessária."
            ;;
    esac
    
    # Instala Go
    if ! check_command go; then
        install_go
    else
        msg "Go já está instalado"
    fi
    
    # Configura ambiente Go
    setup_environment
    
    # Instala ferramentas Python
    install_python_deps
    
    # Instala ferramentas Go
    install_tools_go
    
    # Instala ferramentas específicas
    install_arjun
    install_js_tools
    
    # Configura Nuclei
    install_nuclei_templates
    
    # Configura GF
    install_gf_patterns
    
    # Verifica instalações
    verify_installations
    
    # Cria script de teste
    create_test_script
    
    echo -e "\n${VERDE}#------------------------------------------------------------#${RESET}"
    echo -e "${VERDE} [✓] INSTALAÇÃO CONCLUÍDA COM SUCESSO! [✓] ${RESET}"
    echo -e "${VERDE}#------------------------------------------------------------#${RESET}"
    
    echo -e "\n${BRANCO}Próximos passos:${RESET}"
    echo "1. Feche e reabra o terminal ou execute: ${AZUL}source ~/.bashrc${RESET}"
    echo "2. Teste as instalações: ${AZUL}./test_dependencies.sh${RESET}"
    echo "3. Execute seu script: ${AZUL}./ultra_recon.sh alvo.com${RESET}"
    echo ""
    echo -e "${AMARELO}Nota: Algumas ferramentas podem precisar de configuração adicional.${RESET}"
}

# Executa o script principal
main
