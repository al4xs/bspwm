#Nist Gov
while :;
do
	curl -s "https://services.nvd.nist.gov/rest/json/cves/2.0/?pubStartDate=$(date -d 'yesterday' +'%Y-%m-%dT%H:%M:%S')%2B01:00&pubEndDate=$(date +'%Y-%m-%dT%H:%M:%S')%2B01:00" | jq -r '.vulnerabilities | .[].cve | "ID: \(.id)\nDescription: \(.descriptions[0].value)\nStatus: \(.vulnStatus)\n----------------------"' | anew cve-nistgov
	sleep 1d
done

#path tuesday
while :;
do
	while true; do url=$(curl -s 'https://api.msrc.microsoft.com/updates' | jq -r '.value[].[]' | tail -n 1); for cve in $(curl -s "$url" | grep -iEo "[A-Z]{3}\-[0-9]{4}\-[0-9]{4}" | uniq | sort -u); do resultado=$(curl -s "https://api.msrc.microsoft.com/sug/v2.0/en-US/vulnerability/$cve" | jq -r '.releaseDate, .cveTitle, .mitreUrl, .unformattedDescription' | tr '\n' ' '); if [ -n "$resultado" ]; then echo "$resultado"; fi; done; done | anew path-tuesday
	sleep 1d
done
