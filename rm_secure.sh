#! /bin/bash  
sauvegarde_rm=~/.rm_saved/

function rm {
	local opt_force=0
	local opt_interactive=0
	local opt_recursive=0
	local opt_verbose=0 
	local opt_empty=0
	local opt_list=0
	local opt_restore=0
	local opt=0
	OPTERR=0
	#analyse arg ligne de commancde 
	while getopts ":dfirRevls-:" opt ; do 
		case $opt  in 
		d ) ;; #ignoré
		f )
			opt_force=1 ;; 
		i )
			opt_interactive=1 ;; 
		r | R ) 
			opt_recursive=1 ;; 
		e ) 
			opt_empty=1 ;; 
		l ) 
			opt_list=1 ;; 
		s ) 
			opt_restore=1 ;; 
		v ) 
			opt_verbose=1 ;; 
		- ) case $OPTARG in  
			directory ) ;; 
			force ) 
				opt_force=1 ;; 
			interactive ) 
				opt_interactive=1 ;; 
			recursive )
				opt_recursive=1 ;; 
			verbose )
				opt_verbose=1 ;; 
			help ) 
				/bin/rm --help 
				echo "rm_secure:" 
				echo "-e  empty		vider la corbeille" 
				echo "-l  list		voir les fihiers sauvés" 
				echo "-s  restore	récupérer des fichiers" 
				return 0 ;; 
			version )
				/bin/rm --version	
				echo "(rm_secure 1.2)" 
				return 0 ;; 
			empty ) 
				opt_empty=1 ;; 
			list ) 
				opt_list=1 ;; 
			restore )
				opt_restore=1 ;; 
			* )  
				echo "option illegale --$OPTARG" 
				return 1 ;; 
			esac ;; 
		? ) 
			echo "option illegale -$OPTARG" 
			return 1 ;; 
		esac 
	done
	shift $(($OPTIND - 1 )) 
	
	#creer eventuellement un nouveau repertoire 
	if [ !  -d "$sauvegarde_rm" ] ; then 
		mkdir "$sauvegarde_rm" 
	fi

	#vider la poubelle 
	if [ $opt_empty -ne 0 ] ; then 
		/bin/rm	-rf "$sauvegarde_rm"
		return 0 
	fi

	#liste des fichiers sauvés
	if [ $opt_list -ne 0 ]  ; then 
		( cd $sauvegarde_rm 
		ls -lt  )
	fi 

	#recuperation des fichiers 
	if [ $opt_restore -ne 0 ] ; then 
		while [ -n "$1" ] ; do 
			mv "${sauvegarde_rm}/$1" .
			shift 
		done
	return 
	fi

	#suppression des fichiers 
	while [ -n "$1" ] ; do 
	 #suppression interactive 
		 if [ $opt_force -ne 1 ] &&  [ $opt_interactive -ne 0 ] ; then 
			local reponse 
			echo -n "Detruire $1 ? "			
			read reponse 
			if [ "$reponse" != "y" ] && [ "$reponse" != "Y" ] && [ "$reponse" != "o" ] && [ "$reponse" != "O" ] ; then  
				shift 
				continue 
			fi
		fi
		if [ -d "$1" ] && [ $opt_recursive -ne 0 ] ; then 
		# repertoires necessitent option recursives 
			shift 
			continue
		fi
		if [ $opt_verbose -ne 0 ] ; then 
			echo "Suppression de $1" 
		fi 
		mv -f "$1" "$sauvegarde_rm/"
		shift 
	done 
}

trap "/bin/rm -rf $sauvegarde_rm" EXIT 
			
		
