FROM centos:7

# Vendor digital signature
RUN yum update -y && yum install -y iputils telnet
# + [telnet] permettra des tests de la forme : 
#   telnet nom_hote_reseau numero_port
# + [netcat] permettra des tests de la forme : 
#   nc -l nom_hote_reseau:numero_port
#   # avec un client TCP permettant d'envoyer des requêtes TCP vers [nom_hote_reseau:numero_port]
CMD ["/bin/bash"]
