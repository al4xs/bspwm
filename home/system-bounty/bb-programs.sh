#!/bin/bash

# Função para baixar e organizar os programas de bug bounty
organize () {
    url="https://raw.githubusercontent.com/projectdiscovery/public-bugbounty-programs/main/chaos-bugbounty-list.json"
    json_input=$(curl -s "$url")

    for index in $(jq -c '.programs | keys[]' <<< "$json_input"); do
        platform=$(jq -r ".programs[$index].url" <<< "$json_input" | sed -e 's/"//' | sed -e 's/"//' | sed -e 's/www\.//' | sed -e 's/app\.//' | cut -d '.' -f 1 | cut -d '/' -f 3)
        name_program=$(jq -r ".programs[$index].name" <<< "$json_input" | tr " " "-" | sed -e 's/"//' | sed -e 's/"//')
        bounty_status=$(jq -r ".programs[$index].bounty" <<< "$json_input")
        escope=$(jq -r ".programs[$index].domains[]" <<< "$json_input" | tr "," "\n" | sed 's/"//g')

        if [ "$bounty_status" = "true" ]; then
            if [ ! -d "scope-programs/$platform/$name_program" ]; then
                mkdir -p "scope-programs/$platform/$name_program"
            fi

            if [ -n "$escope" ]; then
                echo "$escope" > "scope-programs/$platform/$name_program/scope"
            else
                echo "Nenhum domínio definido ainda"
            fi
        fi
    done
}

# Função para scanear programas
scan () {
    mkdir -p monitor/geral
    echo -e "\033[35m[*]\033[0m Baixando programas h1 privados"
    bbscope h1 -t JwtfErX+byPdgp91KC1TfOFu2NP0luNnCaSezmtiXuQ= -u al4xs -p | anew monitor/geral/h1programaspriv
    echo -e "\033[35m[*]\033[0m Baixando programas h1 pagos"
    bbscope h1 -t JwtfErX+byPdgp91KC1TfOFu2NP0luNnCaSezmtiXuQ= -u al4xs -b | anew monitor/geral/h1programaspagos
    echo -e "\033[35m[*]\033[0m Baixando programas h1 geral"
    bbscope h1 -t JwtfErX+byPdgp91KC1TfOFu2NP0luNnCaSezmtiXuQ= -u al4xs | anew monitor/geral/h1geral
    echo -e "\033[35m[*]\033[0m Baixando programas intigriti privados"
    bbscope it -t 4CAEF58C481CF17B9F5E04B4217B70B68B506A71403EBD8631F77D5788BB4B3A-1 -p | anew monitor/geral/itprogramaspriv
    echo -e "\033[35m[*]\033[0m Baixando programas intigriti pagos"
    bbscope it -t 4CAEF58C481CF17B9F5E04B4217B70B68B506A71403EBD8631F77D5788BB4B3A-1 -b | anew monitor/geral/itprogramaspagos
    echo -e "\033[35m[*]\033[0m Baixando programas intigriti geral"
    bbscope it -t 4CAEF58C481CF17B9F5E04B4217B70B68B506A71403EBD8631F77D5788BB4B3A-1 | anew monitor/geral/itgeral

    # Extrair URLs do arquivo JSON remoto, filtrar e ordenar
    echo -e "\033[35m[*]\033[0m Baixando programas geral do chaos"
    allurls=$(curl -s "https://raw.githubusercontent.com/projectdiscovery/public-bugbounty-programs/main/chaos-bugbounty-list.json" | jq -c ".programs[].domains[]" | sed -e 's/"//g' | tr "-" " " | grep -v " " | grep -v "\.onion" | sort -u)

    # Salvar as URLs em um arquivo
    echo -e "\033[35m[*]\033[0m Criando arquivo de escopo geral do chaos"
    echo "$allurls" > monitor/geral/chaosgeral
    cat monitor/geral/h1geral monitor/geral/itgeral monitor/geral/chaosgeral | anew monitor/geral/geralprograms
    echo -e "\033[35m[*]\033[0m Criando arquivo para programas privados"
    cat monitor/geral/h1programaspriv monitor/geral/itprogramaspriv | anew monitor/geral/programaspriv
    echo -e "\033[35m[*]\033[0m Criando arquivo para programas pagos"
    cat monitor/geral/h1programaspagos monitor/geral/itprogramaspagos | anew monitor/geral/programaspagos
}


# Função para monitorar os programas
monitore () {
    echo -e "\033[35m[*]\033[0m Iniciando Primeiro Scan..."
    scan
    echo -e "\033[35m[*]\033[0m Iniciando ASM de escopo Intigriti/HackerOne"
    # Criar diretório de monitoramento se não existir
        while true; do
            # Executar comandos para monitorar programas
            echo -e "\033[35m[*]\033[0m Iniciando Novo Scan de programas em loop"
            echo -e "\033[35m[*]\033[0m Scan de programas hackerone"
            bbscope h1 -t JwtfErX+byPdgp91KC1TfOFu2NP0luNnCaSezmtiXuQ= -u al4xs -p | anew monitor/geral/h1programaspriv
            bbscope h1 -t JwtfErX+byPdgp91KC1TfOFu2NP0luNnCaSezmtiXuQ= -u al4xs -b | anew monitor/geral/h1programaspagos
            bbscope h1 -t JwtfErX+byPdgp91KC1TfOFu2NP0luNnCaSezmtiXuQ= -u al4xs | anew monitor/geral/h1geral
            echo -e "\033[35m[*]\033[0m Scan de programas Intigriti"
            bbscope it -t 4CAEF58C481CF17B9F5E04B4217B70B68B506A71403EBD8631F77D5788BB4B3A-1 -p | anew monitor/geral/itprogramaspriv
            bbscope it -t 4CAEF58C481CF17B9F5E04B4217B70B68B506A71403EBD8631F77D5788BB4B3A-1 -b | anew monitor/geral/itprogramaspagos
            bbscope it -t 4CAEF58C481CF17B9F5E04B4217B70B68B506A71403EBD8631F77D5788BB4B3A-1 | anew monitor/geral/itgeral
            allurls=$(curl -s "https://raw.githubusercontent.com/projectdiscovery/public-bugbounty-programs/main/chaos-bugbounty-list.json" | jq -c ".programs[].domains[]" | sed -e 's/"//g' | tr "-" " " | grep -v " " | grep -v "\.onion" | sort -u)

            # Salvar as URLs em um arquivo
            echo "$allurls" | anew monitor/geral/chaosgeral
            cat monitor/geral/h1geral monitor/geral/itgeral monitor/geral/chaosgeral | anew monitor/geral/geralprograms
            echo -e "\033[35m[*]\033[0m Notificando novos programas"
            sleep 2
	    echo -e "\033[35m[*]\033[0m Criando arquivo para programas privados"
            cat monitor/geral/h1programaspriv monitor/geral/itprogramaspriv | anew monitor/geral/programaspriv > monitor/geral/priv.new | notify -i monitor/geral/priv.new -id asmprog -silent -bulk -mf "Novos programas privados encontrados em $(pwd)/priv.new : {{{{data}}}} $(date)"
	    echo -e "\033[35m[*]\033[0m Criando arquivo para programas pagos"
            cat monitor/geral/h1programaspagos monitor/geral/itprogramaspagos | anew monitor/geral/programaspagos > monitor/geral/pagos.new | notify -i monitor/geral/pagos.new -id asmprog -silent -bulk -mf "Novos programas pagos encontrados em $(pwd)/pagos.new : {{{{data}}}} $(date)"
            echo -e "\033[35m[*]\033[0m Aguardando 30 Segundos"
            sleep 5;  # Aguardar 30 minutos antes da próxima verificação
        done
}

# Verificar se há argumentos passados
if [ $# -eq 0 ]; then
    echo " "
    echo "Usage: bb-programas.sh -monitore"
    echo "Usage: bb-programas.sh -download"
    echo " "
    echo " "
    echo "-download        | faz download dos programas e organiza por escopo"
    echo "-monitore        | faz asm e monitoramento de programas novos pagos e privados"
    echo " "
    echo " "

    exit 1
fi

# Verificar os argumentos passados e definir as variáveis de controle correspondentes
while [[ $# -gt 0 ]]; do
    case "$1" in
        -download)
            baixar=true
            ;;
        -monitore)
            monitorar=true
            ;;
        *)
            echo "Argumento inválido: $1"
            exit 1
            ;;
    esac
    shift
done

# Executar as funções correspondentes
if [ "$baixar" = true ]; then
    organize
fi

if [ "$monitorar" = true ]; then
    monitore
fi
