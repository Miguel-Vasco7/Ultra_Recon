### 1. Arquivo de Requisitos (install.sh)

Este script instala todas as dependências que o seu código chama (`subfinder`, `nuclei`, `gau`, `arjun`, etc.).

#!/bin/bash
# install.sh - Instalador de dependências para ULTRA RECON

echo -e "\033[1;34m[*] Instalando dependências do sistema...\033[0m"
sudo apt-get update
sudo apt-get install -y gold-bug jq python3 python3-pip curl git-core

# Instalar GO se não existir
if ! command -v go &> /dev/null; then
    echo -e "\033[1;33m[!] Instalando GoLang...\033[0m"
    wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
    sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz
    export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
    echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.bashrc
fi

echo -e "\033[1;34m[*] Instalando ferramentas via GO...\033[0m"
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/lc/gau/v2/cmd/gau@latest
go install -v github.com/tomnomnom/waybackurls@latest
go install -v github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/tomnomnom/gf@latest

echo -e "\033[1;34m[*] Instalando ferramentas via Python...\033[0m"
pip3 install arjun

echo -e "\033[1;34m[*] Configurando GF Patterns...\033[0m"
mkdir -p ~/.gf
git clone https://github.com/tomnomnom/gf ~/gf-temp
cp ~/gf-temp/examples/*.json ~/.gf
rm -rf ~/gf-temp
git clone https://github.com/1ndianl33t/Gf-Patterns ~/gf-patterns-temp
cp ~/gf-patterns-temp/*.json ~/.gf
rm -rf ~/gf-patterns-temp

echo -e "\033[1;32m[!] Instalação Concluída! Reinicie o terminal ou dê 'source ~/.bashrc'\033[0m"

### 2. README.md para o GitHub
# 🚀 ULTRA RECON - Bug Bounty Automation

O **ULTRA RECON** é um script de automação de alto impacto para segurança ofensiva e Bug Bounty. Ele realiza desde a enumeração de subdomínios até o escaneamento ativo de vulnerabilidades críticas.

## 🛠️ Funcionalidades
- **Fase 1-3:** Enumeração passiva e ativa de subdomínios (Subfinder, Amass, CRT.sh).
- **Fase 4:** Validação de hosts vivos e detecção de tecnologias (HTTPX).
- **Fase 5:** Mineração massiva de URLs e endpoints (GAU, Waybackurls, Katana).
- **Fase 6:** Filtragem inteligente por extensões (JS, API, SENSITIVE).
- **Fase 7:** Descoberta de parâmetros ocultos (Arjun).
- **Fase 8:** Scanning direcionado de vulnerabilidades (Nuclei - SQLi, XSS, RCE, CVEs).

## 📋 Pré-requisitos
Certifique-se de ter o **Go 1.19+** e **Python 3** instalados.

## 🚀 Como instalar

git clone [https://github.com/seu-usuario/ultra-recon.git](https://github.com/seu-usuario/ultra-recon.git)
cd ultra-recon
chmod +x install.sh recon.sh
./install.sh
source ~/.bashrc

## 💻 Como usar

```bash
./recon.sh alvo.com

## 📂 Estrutura de Resultados

Ao final de cada scan, uma pasta `BB_alvo_timestamp` é criada com:

* vulns/: Vulnerabilidades confirmadas pelo Nuclei.
* filters/: URLs suspeitas filtradas para análise manual.
* results/REPORT.md: Um resumo completo em Markdown.

## ⚠️ Aviso Legal

Este script foi desenvolvido para fins educacionais e testes de segurança autorizados. O uso em alvos sem permissão é ilegal.
Desenvolvido por **Miguel Vasco** | Security Researcher


**Gostaria que eu criasse um arquivo `.gitignore` para o seu repositório não ficar cheio de logs de testes quando você subir pro GitHub?**

```
