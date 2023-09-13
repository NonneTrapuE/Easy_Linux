#!/bin/bash

############
# hosts.sh #
#########################################################################################################################
#															#
#															#
#															#
#	Permet d'éditer le fichier de configuration /etc/hosts pour la résolution du nom par le serveur DNS.		#
#															#
#															#
#															#
#	Script réalisé par NonneTrapuE dans le cadre du projet Easy Linux.						#
#															#
#########################################################################################################################
#															#
#															#
#	Améliorations prévues : 											#
#				- Refactorisation									#
#															#
#															#
#########################################################################################################################




# Sélection de l'interface 2, suivant celle de loopback
INTERFACE=$(ip a | grep 2: | cut --delimiter=":" -f 2 | xargs)

#Sélection de l'IPv4 de la machine sur l'interface 2 
IP_ADDRESS=$(ip a | grep $INTERFACE | grep inet  | awk '{print $2}' | cut --delimiter="/" -f 1)

#Définition du hostname
HOSTNAME=$(hostname)

#Début de la boucle
while :
do

	IP=$(whiptail --title "Configuration du nom DNS" --inputbox "Configuration de l'adresse IP.\nL'adresse par défaut est celle de l'interface 2.\n\n" 15 50 $IP_ADDRESS --ok-button "Suivant" 3>&1 1>&2 2>&3)
	EXIT=$?

	#Test de la variable $IP, si ok -> suivant, sinon retour au début

	if [[ ! -z "$IP" && $EXIT == "0" ]]; then

		while :
		do
			#Création du nom de la machine
			HOSTNAME_SET=$(whiptail --title "Nom d'hôte de la machine" --inputbox "Configuration du nom de la machine.\nPar défaut, il s'agit du nom attribué à la machine\n\n" 15 50 $HOSTNAME --ok-button "Suivant" --cancel-button "Précédent" 3>&1 1>&2 2>&3)
			EXIT=$?

			if [[ ! -z "$HOSTNAME_SET" && $EXIT == "0" ]]; then
				
				#Création du FQDN
				FQDN_SET=$(whiptail --title "FQDN de la machine" --inputbox "Configuration du FQDN de la machine." 10 35 $HOSTNAME_SET --ok-button "Suivant" 3>&1 1>&2 2>&3)
				EXIT=$?

				if [[ ! -z "$FQDN_SET" && $EXIT == "0" ]]; then
			
					#Ajout dans le fichier /etc/hosts
					HOSTS_SET=$(whiptail --title "Ajout dans le fichier hosts" --yesno "Ajouter dans le fichier ? \n\n*$IP\n*$HOSTNAME_SET\n*$FQDN_SET" 15 40 --yes-button "Créer" --no-button "Annuler" --defaultno 3>&1 1>&2 2>&3)
					SET_FILE=$?

					if [[ $SET_FILE == 0 ]]; then

						echo -e "$IP\t$HOSTNAME_SET\t$FQDN_SET" >> /etc/hosts
						ERROR=$?

						if [[ $ERROR == "0" ]]; then
							#Réussite du programme
							whiptail --title "Modification effectuée" --msgbox "La modification a été effectuée.\n\nLe programme va fermer." 15 50
							exit 0
						else
							#Echec du programme
							whiptail --title "Information" --msgbox "Une erreur est survenue. Vous devriez relancer le programme avec sudo.\nPour se faire, tapez la commande :\nsudo ./hosts.sh" 15 50
							exit 1
						fi

					else
						break
					fi

				elif [[ ! $EXIT == "0" ]]; then
					break
				else
					whiptail --title "Erreur" --msgbox "Le champs est vide" 10 30
				fi

			elif [[ ! $EXIT == "0" ]]; then
				break
			else
				whiptail --title "Erreur" --msgbox "Le champs est vide" 10 30
			fi
		done

	elif [[ ! $EXIT == 0 ]]; then

		#Quitte l'application avec le code de sortie adéquat
		exit $EXIT

	else

		whiptail --title "Erreur" --msgbox "Le champs est vide." 10 30

	fi

done
#Fin de la boucle
