#!/bin/bash


# VERSION_IMAGE_CENTOS=centos:7
export ID_IMAGE_CENTOS=$(cat ./.env|grep VERSION_IMAGE_CENTOS | awk -F = '{print $2}')


# VERSION_IMAGE_MONGO=mongo:latest
export ID_IMAGE_MONGO=$(cat ./.env|grep VERSION_IMAGE_MONGO | awk -F = '{print $2}')

# VERSION_IMAGE_GITLAB_CE=gitlab/gitlab-ce:latest
# export ID_IMAGE_GITLAB_CE=$(cat ./.env|grep VERSION_IMAGE_GITLAB_CE | awk -F = '{print $2}')
export CETTE_GITLAB_CE_VERSION=$(cat ./.env|grep GITLAB_CE_VERSION | awk -F = '{print $2}')
export ID_IMAGE_GITLAB_CE="gitlab/gitlab-ce:$CETTE_GITLAB_CE_VERSION"

# VERSION_IMAGE_GITLAB_RUNNER=gitlab/gitlab-runner:latest
# export ID_IMAGE_GITLAB_RUNNER=$(cat ./.env|grep VERSION_IMAGE_GITLAB_RUNNER | awk -F = '{print $2}')
export ID_IMAGE_GITLAB_RUNNER=$(cat ./.env|grep GITLAB_RUNNER_VERSION | awk -F = '{print $2}')
export ID_IMAGE_GITLAB_RUNNER="gitlab/gitlab-runner:$ID_IMAGE_GITLAB_RUNNER"

# VERSION_IMAGE_ROCKETCHAT=rocketchat/rocket.chat:latest
export ID_IMAGE_ROCKETCHAT=$(cat ./.env|grep VERSION_IMAGE_ROCKETCHAT | awk -F = '{print $2}')

# VERSION_IMAGE_HUBOT_ROCKETCHAT=rocketchat/hubot-rocketchat:latest
export ID_IMAG_HUBOT_ROCKETCHAT=$(cat ./.env|grep VERSION_IMAGE_HUBOT_ROCKETCHAT | awk -F = '{print $2}')

# VERSION_IMAGE_NGINX=nginx:latest
export ID_IMAG_HUBOT_NGINX=$(cat ./.env|grep VERSION_IMAGE_NGINX | awk -F = '{print $2}')


export ID_IMAGE_JENKINS=$(cat ./.env|grep VERSION_IMAGE_JENKINS | awk -F = '{print $2}')

echo "   "
echo "   "
echo "  -------------------------------------------  "
echo "  +  initialisation-iaac-cible-deploiement.sh "
echo "  -------------------------------------------  "
echo "    ID_IMAGE_CENTOS=$ID_IMAGE_CENTOS "
echo "  -------------------------------------------  "
echo "    ID_IMAGE_MONGO=$ID_IMAGE_MONGO "
echo "  -------------------------------------------  "
echo "    ID_IMAGE_GITLAB_CE=$ID_IMAGE_GITLAB_CE "
echo "  -------------------------------------------  "
echo "    ID_IMAGE_GITLAB_RUNNER=$ID_IMAGE_GITLAB_RUNNER "
echo "  -------------------------------------------  "
echo "    ID_IMAGE_ROCKETCHAT=$ID_IMAGE_ROCKETCHAT "
echo "  -------------------------------------------  "
echo "    ID_IMAG_HUBOT_ROCKETCHAT=$ID_IMAG_HUBOT_ROCKETCHAT "
echo "  -------------------------------------------  "
echo "    ID_IMAG_HUBOT_NGINX=$ID_IMAG_HUBOT_NGINX "
echo "  -------------------------------------------  "
echo "    ID_IMAGE_JENKINS=$ID_IMAGE_JENKINS "
echo "  -------------------------------------------  "
echo "   "
echo "   "



# + Permet d'initialiser le contexte de déploimeent, la cible de déploiement, pour un cycle IAAC
docker pull "$ID_IMAGE_CENTOS"
docker pull "$ID_IMAGE_MONGO"
docker pull "$ID_IMAGE_GITLAB_CE"
docker pull "$ID_IMAGE_GITLAB_RUNNER"
docker pull "$ID_IMAGE_ROCKETCHAT"
docker pull "$ID_IMAGE_HUBOT_ROCKETCHAT"
docker pull "$ID_IMAGE_NGINX"
docker pull "$ID_IMAGE_JENKINS"
