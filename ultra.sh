#!/bin/bash
# BUG BOUNTY ULTIMATE - CERTO QUE FUNCIONA

# CRT, bota seu alvo aqui
TARGET="$1"
[ -z "$TARGET" ] && { echo "CERTO: $0 <alvo.com>"; exit 1; }

# Pasta com TIMESTAMP exato
DIR_NAME="BB_$(echo $TARGET | cut -d. -f1)_$(date +%s)"
echo "🔥 CRIANDO: $DIR_NAME"

# Cria TUDO
mkdir -p "$DIR_NAME"
cd "$DIR_NAME" || { echo "FALHOU CD"; exit 1; }

# PASTAS COMPLETAS
mkdir -p {recon,ativos,urls,js,apis,arjun,vulns,results,katana,wayback}

echo "📁 ESTRUTURA:"
ls -la

echo -e "\n========== PHASE 1: SUBS =========="
# 1. SUBFINDER FORTE
echo "[1] SUBFINDER..."
subfinder -d "$TARGET" -silent -o recon/subs1.txt
echo "Subs1: $(wc -l recon/subs1.txt)"

# 2. AMASS
echo "[2] AMASS..."
amass enum -passive -d "$TARGET" -silent -o recon/subs2.txt
echo "Subs2: $(wc -l recon/subs2.txt)"

# 3. CRT.SH DIRETO
echo "[3] CRT.SH..."
curl -s "https://crt.sh/?q=%25.$TARGET&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u > recon/subs3.txt
echo "Subs3: $(wc -l recon/subs3.txt)"

# UNIR TUDO
cat recon/subs*.txt | sort -u > recon/all_subs.txt
TOTAL_SUBS=$(wc -l < recon/all_subs.txt)
echo "✅ TODOS SUBS: $TOTAL_SUBS"

echo -e "\n========== PHASE 2: ATIVOS =========="
# HTTPX COMPLETO
echo "[4] HTTPX..."
httpx -l recon/all_subs.txt -silent -status-code -title -tech-detect -o ativos/full.txt
cut -d' ' -f1 ativos/full.txt > ativos/urls.txt
ATIVOS=$(wc -l < ativos/urls.txt)
echo "✅ ATIVOS: $ATIVOS"

echo -e "\n========== PHASE 3: URLS =========="
# 5. WAYBACKURLS
echo "[5] WAYBACKURLS..."
waybackurls "$TARGET" > urls/wayback.txt
echo "Wayback: $(wc -l urls/wayback.txt)"

# 6. KATANA PESADO
echo "[6] KATANA..."
if [ $ATIVOS -gt 0 ]; then
    katana -l ativos/urls.txt -silent -jc -kf -c 15 -d 3 > urls/katana.txt 2>/dev/null || echo "Katana falhou mas ok"
    echo "Katana: $(wc -l urls/katana.txt 2>/dev/null || echo 0)"
fi

# JUNTAR URLS
cat urls/*.txt 2>/dev/null | sort -u > urls/all_urls.txt
TOTAL_URLS=$(wc -l < urls/all_urls.txt 2>/dev/null || echo 0)
echo "✅ TOTAL URLS: $TOTAL_URLS"

echo -e "\n========== PHASE 4: FILTROS =========="
# 7. JS FILES
echo "[7] JS FILES..."
grep -i "\.js$" urls/all_urls.txt 2>/dev/null > js/all_js.txt
JS_COUNT=$(wc -l < js/all_js.txt 2>/dev/null || echo 0)
echo "JS Files: $JS_COUNT"

# 8. APIS
echo "[8] APIS..."
grep -Ei "(api|v[0-9]|rest|graphql|\.php|\.asp|\.aspx|\.jsp)" urls/all_urls.txt 2>/dev/null > apis/all_apis.txt
API_COUNT=$(wc -l < apis/all_apis.txt 2>/dev/null || echo 0)
echo "APIs: $API_COUNT"

# 9. ARJUN TARGETS
echo "[9] PREP ARJUN..."
grep -E "^https?://[^?]+\?" urls/all_urls.txt 2>/dev/null > arjun/with_params.txt
cat arjun/with_params.txt apis/all_apis.txt 2>/dev/null | sort -u > arjun/targets.txt
ARJUN_TARGETS=$(wc -l < arjun/targets.txt 2>/dev/null || echo 0)
echo "Arjun Targets: $ARJUN_TARGETS"

echo -e "\n========== PHASE 5: ARJUN =========="
if [ $ARJUN_TARGETS -gt 0 ]; then
    echo "[10] ARJUN RODANDO..."
    # Pega top 10 para não demorar
    head -10 arjun/targets.txt > arjun/top10.txt
    arjun -i arjun/top10.txt -t 10 -m GET -oT arjun/results.txt 2>&1 | tail -5
    
    # Processa resultados
    if [ -f arjun/results.txt ]; then
        grep -E "^https?://" arjun/results.txt | sort -u > arjun/urls_with_params.txt
        echo "Arjun encontrou: $(wc -l < arjun/urls_with_params.txt 2>/dev/null || echo 0) parâmetros"
    fi
fi

echo -e "\n========== PHASE 6: NUCLEI =========="
# 11. NUCLEI PESADO
echo "[11] NUCLEI HIGH..."
if [ $ATIVOS -gt 0 ]; then
    nuclei -l ativos/urls.txt -silent -severity high,critical -o vulns/high.txt 2>&1 | tail -3
    echo "Vulns High: $(wc -l vulns/high.txt 2>/dev/null || echo 0)"
    
    echo "[12] NUCLEI CVES..."
    nuclei -l ativos/urls.txt -silent -t cves/ -severity medium,high,critical -o vulns/cves.txt 2>&1 | tail -3
    
    echo "[13] NUCLEI SECRETS..."
    if [ $JS_COUNT -gt 0 ]; then
        nuclei -l js/all_js.txt -silent -t exposures/tokens -o vulns/secrets.txt 2>&1 | tail -2
    fi
    
    echo "[14] NUCLEI APIS..."
    if [ $API_COUNT -gt 0 ]; then
        nuclei -l apis/all_apis.txt -silent -t http/misconfiguration/ -o vulns/apis.txt 2>&1 | tail -2
    fi
fi

echo -e "\n========== PHASE 7: SENSITIVE =========="
# 15. ARQUIVOS SENSÍVEIS
echo "[15] SENSITIVE FILES..."
grep -Ei "\.(env|git|config|sql|bak|backup|tar|gz|zip|old)$" urls/all_urls.txt 2>/dev/null > results/sensitive.txt
echo "Sensitive: $(wc -l results/sensitive.txt 2>/dev/null || echo 0)"

# 16. OPEN REDIRECT
echo "[16] OPEN REDIRECT..."
grep -Ei "(url|redirect|next|dest|return|goto)=" urls/all_urls.txt 2>/dev/null > results/redirects.txt
echo "Redirects: $(wc -l results/redirects.txt 2>/dev/null || echo 0)"

echo -e "\n========== PHASE 8: RELATÓRIO =========="
# 17. RESUMÃO
cat > results/REPORT.md << EOF
# 🚀 BUG BOUNTY REPORT - $TARGET
**Data:** $(date)
**Pasta:** $(pwd)

## 📊 ESTATÍSTICAS
- **Subdomínios:** $TOTAL_SUBS
- **Hosts Ativos:** $ATIVOS
- **URLs Coletadas:** $TOTAL_URLS
- **Arquivos JS:** $JS_COUNT
- **Endpoints API:** $API_COUNT
- **Targets Arjun:** $ARJUN_TARGETS

## 📁 ESTRUTURA
\`\`\`
$(find . -type d | sort | sed 's/^/  /')
\`\`\`

## 📄 ARQUIVOS IMPORTANTES
1. \`recon/all_subs.txt\` - Todos subdomínios
2. \`ativos/urls.txt\` - URLs ativas
3. \`vulns/high.txt\` - Vulnerabilidades críticas
4. \`arjun/results.txt\` - Parâmetros descobertos
5. \`js/all_js.txt\` - Arquivos JavaScript
6. \`apis/all_apis.txt\` - Endpoints API

## 🔍 PRÓXIMOS PASSOS
1. Analise \`vulns/high.txt\` primeiro
2. Teste parâmetros em \`arjun/urls_with_params.txt\`
3. Procure segredos em \`js/all_js.txt\`
4. Escaneie APIs em \`apis/all_apis.txt\`

## ⚡ COMANDOS PARA CONTINUAR
\`\`\`bash
# Testar XSS
cat arjun/urls_with_params.txt | dalfox pipe

# Testar SQLi
sqlmap -m ativos/urls.txt --batch

# Mais recon
gospider -S ativos/urls.txt -o results/gospider_out
\`\`\`

## ⏱️ TEMPO DE EXECUÇÃO
Início: $(date)
Fim: $(date)
\`\`\`

**AUTOMAÇÃO COMPLETA!** 🎯
EOF

echo -e "\n========== FINAL =========="
echo "✅✅✅ CONCLUÍDO! ✅✅✅"
echo ""
echo "📂 PASTA: $(pwd)"
echo ""
echo "📊 RESUMO FINAL:"
echo "Subdomínios: $TOTAL_SUBS"
echo "Ativos: $ATIVOS"
echo "URLs: $TOTAL_URLS"
echo "JS: $JS_COUNT"
echo "APIs: $API_COUNT"
echo ""
echo "📄 RELATÓRIO: results/REPORT.md"
echo ""
echo "🔍 ARQUIVOS CRIADOS:"
find . -type f -name "*.txt" -o -name "*.md" | head -20 | while read f; do
    lines=$(wc -l < "$f" 2>/dev/null || echo "0")
    size=$(du -h "$f" 2>/dev/null | cut -f1)
    echo "  - $f ($lines linhas, $size)"
done

echo ""
echo "🚀 PRÓXIMO: Verifique vulns/high.txt primeiro!"
