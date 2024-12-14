while true; do
    resultado2=$(url=$(curl -s 'https://api.msrc.microsoft.com/updates' | jq -r '.value[].[]' | tail -n 1); 
                for cve in $(curl -s "$url" | grep -iEo "[A-Z]{3}\-[0-9]{4}\-[0-9]{4}" | uniq | sort -u); 
                do resultado=$(curl -s "https://api.msrc.microsoft.com/sug/v2.0/en-US/vulnerability/$cve" | jq -r '.releaseDate, .cveTitle, .mitreUrl, .unformattedDescription' | tr '\n' ' '); 
                if [ -n "$resultado" ]; then echo "$resultado"; fi; done)
    
    # Iterando sobre cada linha de resultado2
    IFS=$'\n' # Definindo o separador de campo para nova linha
    for linha in $resultado2; do
        mes=$(echo "$linha" | grep -iEo "[0-9]{4}\-[0-9]{2}\-[0-9]{1,2}" | sed -e "s/\-/ /g" | cut -d " " -f 2); 
        tuesday=$(ncal 2024 -m $mes -C | awk '{print $3}' | tr "\n" " " | sed -e "s/  / /" | cut -d " " -f 4); 
        diaout=$(echo "$linha" | grep -iEo "[0-9]{4}\-[0-9]{2}\-[0-9]{1,2}" | sed -e "s/\-/ /g" | cut -d " " -f 3); 
        if [ "$diaout" == "$tuesday" ]; then echo "$linha"; fi;
    done
done
