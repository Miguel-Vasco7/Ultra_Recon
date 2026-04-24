# 🚀 ULTRA RECON - Miguel Vasco
![Tool Preview](preview.png)

**Automated Web Pentest Reconnaissance Framework**

Developed by **Miguel Vasco**, Ultra Recon is a streamlined automation suite designed for high-efficiency reconnaissance. It maps attack surfaces, filters potential vulnerabilities using logic-based patterns, and validates findings with template-based scanning.

## 🛠️ Core Workflow
The tool follows a professional reconnaissance pipeline:
1.  **Passive Recon:** Subdomain discovery via Subfinder and Crt.sh.
2.  **Validation:** Live host checking using HTTPX.
3.  **Endpoint Mining:** Deep crawling with Katana, Wayback Machine, and GAU.
4.  **Parameter Discovery:** Hidden parameter fuzzing with Arjun.
5.  **Smart Filtering:** Pattern matching with GF and custom Grep logic.
6.  **Vulnerability Scanning:** Automated validation via Nuclei.

## 🚀 Getting Started

### 1. Prerequisites
This tool is designed for Linux (Kali, Parrot, or Ubuntu). You will need `sudo` privileges for the initial setup.

### 2. Environment Setup (Recommended)
To prevent dependency conflicts, it is highly recommended to use a Python Virtual Environment. The built-in installer will handle Go, Python, and System dependencies.

```bash
# Clone the repository and enter the directory
git clone https://github.com/Miguel-Vasco7/Recon_Ultra.git
cd Recon_Ultra

# Create and activate a Virtual Environment
python3 -m venv venv
source venv/bin/activate

# Install all necessary dependencies
chmod +x install_dependencies.sh
./install_dependencies.sh
```

## 💻 Usage
Once the installation is complete, refresh your shell and start scanning:

```bash
# Reload your profile (required for Go paths)
source ~/.bashrc

# Ensure your venv is active and run Ultra Recon
source venv/bin/activate
./ultra_recon.sh example.com
```

## 📁 Output Structure
Ultra Recon organizes results into specialized directories for easy analysis:
* **/recon**: Raw and cleaned subdomain lists.
* **/active**: Validated live hosts.
* **/urls**: Crawled endpoints and cleaned URL sets.
* **/filters**: Potential vulnerabilities grouped by type (XSS, SQLi, LFI).
* **/vulns**: **Confirmed** findings validated by Nuclei.
* **/results**: A final `REPORT.md` with executive statistics.

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
