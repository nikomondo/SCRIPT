#! /bin/bash

# recoit arg le nom fichier et propose differentes actions

function action_fichier ()  {
	local reponse
	local saisie

	echo "============================================="
	PS3="
	Action sur $1: "

	select reponse in Infos Copier Deplacer Detruire Retour 
	do
		case $reponse in 
			Info)
				echo
				ls -l $1
				echo
				;;
			Copier) 
				echo -n "Copier $1 vers ? : " 
				if ! read saisie ; then continue ; fi 
				cp $1 $saisie
				;;
			Deplacer)
				echo -n "Deplacer $1 ver ? : " 
				if ! read saisie ; then continue ; fi 
				mv $1 $saisie
				break
				;;
			Detruire)
				if rm -i $1 ; then break ; fi
				;;
			Retour)
				break
				;;
			*)
				if [ "$REPLY" = "0" ] ; then break; fi
				echo "$REPLY n'est pas une reponse valide"
				echo 
				;;
			esac
	done
}

# fonction affiche les fichiers present dans le repertoire 
# elle applele action_fichier() 
# se termine si on selectione "0" 

function liste_fichier  {



	echo "============================================="
	PS3="Fichier à traiter :" 
	select fichier in * 
	do
		if [ ! -z $fichier ] ; then 
			action_fichier $fichier 
			return 0
		fi 

		if [ "$REPLY" = "0" ] ; then 
			return  1
		fi 

		echo "Entrez 0 pour quitter" 
		echo 
	done 
}

#boucle tant que fonction reussit
# les : signifie ne rien faire 

while liste_fichier; do : ; done 

