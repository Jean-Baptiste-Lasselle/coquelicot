# FROM gitlab/gitlab-ce:${VERSION_IMAGE_GITLAB_CE}
# FROM $VERSION_IMAGE_GITLAB_CE
FROM gitlab/gitlab-ce:11.2.1-ce.0

# USER root

RUN echo " Le fichier /etc/gitlab/gitlazb.rb existe-t-il ? "
# RUN ls -all /etc/gitlab/
RUN echo " Ajout du fichier externe gitlab.rb ==>> "
# RUN rm -f /etc/gitlab/gitlab.rb

ADD ./config/gitlab.rb /etc/gitlab/gitlab.rb
RUN chmod a+rwx /etc/gitlab/gitlab.rb
# USER gitlab
# Le serveur NGINX à l'intérieur du conteneur Gitlab, écoute sur le port 80...
# EXPOSE 80
# Le serveur NGINX à l'intérieur du conteneur Gitlab, écoute sur le port ${GITLAB_HTTP_PORT_VIA_NGINX_INTERNE_GITLAB}...
EXPOSE ${GITLAB_HTTP_PORT_VIA_NGINX_INTERNE_GITLAB}
EXPOSE 443
EXPOSE 22
