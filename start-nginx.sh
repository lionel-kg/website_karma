#!/bin/sh
# Remplacer le port par défaut de Nginx par le port Heroku au moment de l'exécution
sed -i 's/listen  *[0-9]*;/listen '"$PORT"';/' /etc/nginx/conf.d/default.conf

# Démarrer Nginx en arrière-plan
nginx -g 'daemon off;'
