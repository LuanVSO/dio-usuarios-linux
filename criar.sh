#! /usr/bin/env bash

function criar_diretorios {
	if [ $# -lt 1 ]; then
		echo "$0: fução precisa de um caminho de arquivo como primeiro argumento" 1>&2
		return 255
	elif [ ! -f "$1" ]; then
		echo "$0: $1 não é um arquivo" 1>&2
		return 255
	fi

	echo "criando diretorios" 1>&2

	local line
	while read -r line; do
		local folder
		folder=$(echo "$line" | cut -d: -f1)
		mkdir "$folder"
	done <"$1"
}

function criar_grupos {
	if [ $# -lt 1 ]; then
		echo "$0: fução precisa de um caminho de arquivo como primeiro argumento" 1>&2
		return 255
	elif [ ! -f "$1" ]; then
		echo "$0: $1 não é um arquivo" 1>&2
		return 255
	fi

	echo "criando grupos..." 1>&2

	local line
	while read -r line; do
		groupadd "$line"
	done <"$1"
}

function criar_usuarios() {
	if [ $# -lt 1 ]; then
		echo "$0: fução precisa de um caminho de arquivo como primeiro argumento" 1>&2
		return 255
	elif [ ! -f "$1" ]; then
		echo "$0: $1 não é um arquivo" 1>&2
		return 255
	fi

	echo "criando usuarios..." 1>&2

	local bashpath
	bashpath=$(command -v bash)

	local line
	while read -r line; do
		local nome
		nome=$(echo "$line" | cut -d: -f1)
		local pass
		pass=$(echo "$line" | cut -d: -f2)
		local group
		group=$(echo "$line" | cut -d: -f3)
		useradd "$nome" -m -s "$bashpath" -p "$(openssl passwd -1 "$pass")" -G "$group"
	done <"$1"
}

function definir_permissoes_diretorios() {
	if [ $# -lt 1 ]; then
		echo "$0: fução precisa de um caminho de arquivo como primeiro argumento" 1>&2
		return 255
	elif [ ! -f "$1" ]; then
		echo "$0: $1 não é um arquivo" 1>&2
		return 255
	fi

	echo "definindo permissões dos diretórios..."

	local line
	while read -r line; do
		local folder
		folder=$(echo "$line" | cut -d: -f1)
		local group
		group=$(echo "$line" | cut -d: -f3)
		chown -R "root:$group" "$folder"

		local perms
		perms=$(echo "$line" | cut -d: -f2)
		chmod "$perms" "$folder"
	done <"$1"
}

function main() {
	criar_diretorios ./pastas.txt &&
		criar_grupos ./grupos.txt &&
		definir_permissoes_diretorios ./pastas.txt &&
		criar_usuarios ./usuarios.txt &&
		echo "concluido com sucesso" 1>&2 &&
		return 0 || echo "falhou" 1>&2 && return 255
}

main
