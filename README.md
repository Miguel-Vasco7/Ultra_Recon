Aqui está a versão atualizada e completa do seu **README.md**. Adicionei a seção de instalação automática (usando o seu script de dependências) e as instruções de como você deve colocar a foto da ferramenta para ela aparecer no GitHub.
# ULTRA RECON 🚀
**Automated Web Pentest Reconnaissance Framework**
Developed by **Miguel Vasco**, Ultra Recon is a streamlined automation suite designed for high-efficiency reconnaissance. It maps attack surfaces, filters potential vulnerabilities using logic-based patterns, and validates findings with template-based scanning.
> **Note:** To display your own screenshot, save your terminal image as preview.png in the root folder of your project.
> 
## 🛠️ Core Workflow
The tool follows a professional reconnaissance pipeline:
 1. **Passive Recon:** Subdomain discovery via Subfinder and Crt.sh.
 2. **Validation:** Live host checking using HTTPX.
 3. **Endpoint Mining:** Deep crawling with Katana and GAU.
 4. **Parameter Discovery:** Hidden parameter fuzzing with Arjun.
 5. **Smart Filtering:** Pattern matching with GF and custom Grep logic.
 6. **Vulnerability Scanning:** Automated validation via Nuclei.
## 🚀 Getting Started
### 1. Prerequisites
This tool is designed for Linux (Kali, Parrot, or Ubuntu). You will need sudo privileges for the initial setup.
### 2. Automatic Installation
You can install all necessary Go, Python, and System dependencies using the built-in installer:
```bash
# Clone the repository
git clone https://github.com/youruser/ultra-recon.git
cd ultra-recon
# Run the dependency installer
chmod +x install_dependencies.sh
./install_dependencies.sh
```
### 3. Environment Setup (Recommended)
After running the installer, it is recommended to use a Python Virtual Environment for specific tasks:
```bash
# Create and activate the environment
python3 -m venv venv
source venv/bin/activate
```
## 💻 Usage
Once the installation is complete, refresh your shell and start scanning:
```bash
# Reload your profile
source ~/.bashrc
# Run Ultra Recon
./ultra_recon.sh example.com
```
## 📁 Output Structure
Ultra Recon organizes results into specialized directories for easy analysis:
 * /recon: Raw and cleaned subdomain lists.
 * /ativos: Validated live hosts.
 * /urls: Crawled endpoints and cleaned URL sets.
 * /filters: Potential vulnerabilities grouped by type (XSS, SQLi, LFI).
 * /vulns: **Confirmed** findings validated by Nuclei.
 * /results: A final REPORT.md with executive statistics.
## 🛡️ Tools Utilized

| Tool | Purpose |
| :--- | :--- |
| **Subfinder** | Passive Subdomain Discovery |
| **HTTPX** | Service Probing & Status Codes |
| **Katana** | Modern Web Crawling |
| **GAU** | Fetching Known URLs |
| **Arjun** | HTTP Parameter Discovery |
| **Nuclei** | Template-based Vulnerability Scanning |
| **URO / GF** | URL Cleaning and Pattern Filtering |

## ⚖️ Disclaimer
*This tool is intended for educational purposes and authorized security auditing only. The developer is not responsible for any misuse or damage caused by this program.*
