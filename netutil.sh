#!/bin/bash


clear

echo -e "Interface\t " " \t IP\n\n"

#Récupère les addresses IP des différentes interfaces
IPtmp=$(ip a | grep -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/[0-9]{1,2}" | awk '{print $2}' | cut -d '/' -f 1 )

	for ((i=0 ; i < $(echo $IPtmp | wc -w); i++ ));do IPs+=($(echo $IPtmp | cut --delimiter=" " -f $(($i+1)))) ; done


#Crée une boucle sur le nombre d'IP dsiponibles
for ((i=0; i < ${#IPs[@]} ; i++)); do

	#Récupère le nom des interfaces et ajoute l'IP récupérée précédemment
 	echo -e "$(ip a | grep "^[0-9]" | cut --delimiter=" " -f 1,2 | awk -v i=$i 'NR==i+1')  \t " " \t  ${IPs[$i]}"

done

echo -e "\n\n"
