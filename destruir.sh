#! /usr/bin/env bash

function apagar_diretorios {
	if [ $# -lt 1 ]; then
		echo "$0: fução precisa de um caminho de arquivo como primeiro argumento" 1>&2
		return 255
	elif [ ! -f "$1" ]; then
		echo "$0: $1 não é um arquivo" 1>&2
		return 255
	fi

	echo "apagando diretorios" 1>&2

	local line
	while read -r line; do
		local folder
		folder=$(echo "$line" | cut -d: -f1)
		rm -rf "$folder"
	done <"$1"
}

function apagar_grupos {
	if [ $# -lt 1 ]; then
		echo "$0: fução precisa de um caminho de arquivo como primeiro argumento" 1>&2
		return 255
	elif [ ! -f "$1" ]; then
		echo "$0: $1 não é um arquivo" 1>&2
		return 255
	fi

	echo "apagando grupos..." 1>&2

	local line
	while read -r line; do
		groupdel "$line"
	done <"$1"
}

function apagar_usuarios() {
	if [ $# -lt 1 ]; then
		echo "$0: fução precisa de um caminho de arquivo como primeiro argumento" 1>&2
		return 255
	elif [ ! -f "$1" ]; then
		echo "$0: $1 não é um arquivo" 1>&2
		return 255
	fi

	echo "apagando usuarios..." 1>&2

	local line
	while read -r line; do
		local nome
		nome=$(echo "$line" | cut -d: -f1)
		userdel "$nome" --remove
	done <"$1"
}

function main() {
	apagar_diretorios ./pastas.txt &&
		apagar_usuarios ./usuarios.txt &&
		apagar_grupos ./grupos.txt &&
		echo "concluido com sucesso" 1>&2 &&
		return 0 || echo "falhou" 1>&2 && return 255
}

main
