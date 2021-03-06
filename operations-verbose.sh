#!/bin/bash

# - ENV 
export NOM_CONTENEUR_HUBOT=hubot
export NOM_CONTENEUR_ROCKETCHAT=rocketchat
export NOM_CONTENEUR_BDD_ROCKETCHAT=mongo
export NOM_CONTENEUR_INIT_REPLICASET_BDD_ROCKETCHAT=mongo-init-replica
export UTILISATEUR_HUBOT_ROCKETCHAT_USERNAME=jbl
export UTILISATEUR_HUBOT_ROCKETCHAT_PWD=jbl

# - Fonctions
# --------------------------------------------------------------------------------------------------------------------------------------------
# 
# Cette fonction permet d'attendre que le conteneur soit dans l'état healthy
# Cette fonction prend un argument, nécessaire sinon une erreur est générée (TODO: à implémenter avec exit code)
checkHealth () {
	export ETATCOURANTCONTENEUR=starting
	export ETATCONTENEURPRET=healthy
	export NOM_DU_CONTENEUR_INSPECTE=$1
	
	while  $(echo "+provision+girofle+ $NOM_DU_CONTENEUR_INSPECTE - HEALTHCHECK: [$ETATCOURANTCONTENEUR]" >> ./check-health.coquelicot); do
	
	ETATCOURANTCONTENEUR=$(sudo docker inspect -f '{{json .State.Health.Status}}' $NOM_DU_CONTENEUR_INSPECTE)
	if [ $ETATCOURANTCONTENEUR == "\"healthy\"" ]
	then
		echo "+provision+girofle+ $NOM_DU_CONTENEUR_INSPECTE est prêt - HEALTHCHECK: [$ETATCOURANTCONTENEUR]"
		break;
	else
		echo "+provision+girofle+ $NOM_DU_CONTENEUR_INSPECTE n'est pas prêt - HEALTHCHECK: [$ETATCOURANTCONTENEUR] - attente d'une seconde avant prochain HealthCheck - "
		sleep 1s
	fi
	done
	rm -f ./check-health.coquelicot
	# DEBUG LOGS
	echo " provision-girofle-  ------------------------------------------------------------------------------ " 
	echo " provision-girofle-  - Contenu du répertoire [/etc/gitlab] dans le conteneur [$NOM_DU_CONTENEUR_INSPECTE]:" 
	echo " provision-girofle-  - " 
	sudo docker exec -it $NOM_DU_CONTENEUR_INSPECTE /bin/bash -c "ls -all /etc/gitlab"
	echo " provision-girofle-  ------------------------------------------------------------------------------ " 
	echo " provision-girofle-  - Existence du fichier [/etc/gitlab/gitlab.rb] dans le conteneur  [$NOM_DU_CONTENEUR_INSPECTE]:" 
	echo " provision-girofle-  - "
	sudo docker exec -it $NOM_DU_CONTENEUR_INSPECTE /bin/bash -c "ls -all /etc/gitlab/gitlab.rb" >> $NOMFICHIERLOG
	echo " provision-girofle-  - " 
	echo " provision-girofle-  ------------------------------------------------------------------------------ " 
}

# - OPS 

# - Je récupère, dans le fichier 'docker-compose.yml', les valeurs de configuration pour le username et le password

# export UTILISATEUR_HUBOT_ROCKETCHAT_USERNAME=$(cat ./docker-compose.yml|grep ROCKETCHAT_USER | awk -F = '{print $2}')
# export UTILISATEUR_HUBOT_ROCKETCHAT_PWD=$(cat ./docker-compose.yml|grep ROCKETCHAT_PASSWORD | awk -F = '{print $2}')

# Depuis l'utiliation du fichier de variables globales [.env]
export UTILISATEUR_HUBOT_ROCKETCHAT_USERNAME=$(cat ./.env|grep UTILISATEUR_ROCKETCHAT_HUBOT | grep -v MDP | awk -F = '{print $2}')
export UTILISATEUR_HUBOT_ROCKETCHAT_PWD=$(cat ./.env|grep UTILISATEUR_ROCKETCHAT_HUBOT_MDP | awk -F = '{print $2}')

clear
echo "  "
echo " ---------------------------------------------------------------------- "
echo "  DEBUG : "
echo " ---------------------------------------------------------------------- "
echo "    - username : \"UTILISATEUR_HUBOT_ROCKETCHAT_USERNAME=$UTILISATEUR_HUBOT_ROCKETCHAT_USERNAME\" "
echo "    - password : \"UTILISATEUR_HUBOT_ROCKETCHAT_PWD=$UTILISATEUR_HUBOT_ROCKETCHAT_PWD\" "
echo "  "
echo "   REMARQUE IMPORTANTE: la création de ce user pourra êtree automatisée avec la REST API RocketChat"
echo "  "
echo "  Pressez la touche entrée.  "
echo " ---------------------------------------------------------------------- "
echo "  "
read DEBUGJBL

# - Je rends exécutables les scripts invoqués dans la présente recette
chmod +x ./initialisation-iaac-cible-deploiement.sh
# J'initialise tout de suite la cible de déploiement
./initialisation-iaac-cible-deploiement.sh

# - Je rends exéutable les fichiers de script utilisés dans les builds d'images Docker qui doivent l'être : 
chmod +x ./mongo-init-replica/construction/*
chmod +x ./mongodb/construction/*
chmod +x ./rocketchat/construction/* 
chmod +x ./hubot-init-rocketcha/construction/* 
# - Je créée "tout"
# docker-compose down --rmi all && docker system prune -f && docker-compose --verbose build && docker-compose --verbose up -d 
# Non, le volume d'images téléchargées est trop grand.
docker-compose down && docker system prune -f && sudo rm -rf ./db/ && docker-compose --verbose up -d --build --force-recreate


# - 1 - Je dois relancer le conteneur qui créée et initialise le replicaSet mongoDB, dès que mongoDB est disponible :
# checkHealth $NOM_CONTENEUR_BDD_ROCKETCHAT
# docker start $NOM_CONTENEUR_INIT_REPLICASET_BDD_ROCKETCHAT

# - 2 - Maintenant que le replicaSet Existe, je peux re-démarrer le conteneur rocketchat
# docker-compose --verbose up -d $NOM_CONTENEUR_ROCKETCHAT 
# sleep 3 && docker ps -a
# docker logs $NOM_CONTENEUR_ROCKETCHAT
# -->> À terme, je voudrais, au lieu de re-démarrer de force le service rocketchat, le laisser re-démarrer, et vérifier que
#      Rocket Chat est dans un état "Healthy", avant de créer manuellement le USER utilisé par le service HUBOT ensuite :
#           pour cela, il faudra donc faire un HEALTHCHECK rocketchat, et invoquer la focntion [checkHealth] de ce script : 
# 
#    checkHealth $NOM_CONTENEUR_ROCKETCHAT
# 
# 
# - 3 - Il faut manuellement créer l'utilisateur RocketChat mentionné dans la configuration du service 'hubot' dans le fichier docker-compose.yml : 
clear
echo "  "
echo " ---------------------------------------------------------------------- "
echo "  Please Create a user in rocketchat, with the following  credentials : "
echo " ---------------------------------------------------------------------- "
echo "    - username : \"UTILISATEUR_HUBOT_ROCKETCHAT_USERNAME=$UTILISATEUR_HUBOT_ROCKETCHAT_USERNAME\" "
echo "    - password : \"UTILISATEUR_HUBOT_ROCKETCHAT_PWD=$UTILISATEUR_HUBOT_ROCKETCHAT_PWD\" "
echo "  "
echo "  Pressez la touche entrée lorsque cela sera fait, le  "
echo "  service HUBOT/ROCKETCHAT sera re-démarré "
echo " ---------------------------------------------------------------------- "
echo "  "
read ATTENTE_CREATION_UTILISATEUR_ROCKETCHAT

# - 4 - Maintenant que l'utilisateur dont le hubot a besoin existe, on re-démarre le hubot : 
docker-compose --verbose up -d $NOM_CONTENEUR_HUBOT
sleep 3 && docker ps -a
# - Maintenant, examinons les logs du conteneur hubot :

docker logs  $NOM_CONTENEUR_HUBOT -f

sleep 3 && docker ps -a


