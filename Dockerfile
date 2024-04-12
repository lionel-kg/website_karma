# Utilise l'image de base Nginx pour servir des fichiers statiques
FROM nginx:alpine

# Copie les fichiers statiques dans le dossier de serveur web de Nginx
COPY . /usr/share/nginx/html

# Expose le port 80 pour permettre l'accès au service Nginx
EXPOSE 80

# Lance Nginx en mode foreground
CMD ["nginx", "-g", "daemon off;"]
