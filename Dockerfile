# Utilise l'image de base Nginx pour servir des fichiers statiques
FROM nginx:alpine

# Copie les fichiers statiques dans le dossier de serveur web de Nginx
COPY . /usr/share/nginx/html

# Copie le script de démarrage personnalisé
COPY start-nginx.sh /start-nginx.sh

# Rends le script exécutable
RUN chmod +x /start-nginx.sh

# Expose le port (Heroku utilisera la variable d'environnement PORT au moment de l'exécution)
EXPOSE $PORT

# Lance le script de démarrage personnalisé
CMD ["/start-nginx.sh"]
