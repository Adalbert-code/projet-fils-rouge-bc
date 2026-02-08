# Utiliser l'image de base officielle Python 3.6 Alpine (légère) 
# Use the official Python 3.6 Alpine base image (lightweight)
FROM python:3.6-alpine

# Définir le répertoire de travail à /opt
# Set the working directory to /opt
WORKDIR /opt

# Copier les fichiers de l'application dans le conteneur
# Copy the application files into the container
COPY . /opt/

# Installer le module Flask à l'aide de pip
# Install the Flask module using pip
RUN pip install flask

# Donner les droits d'exécution au script
# Grant execution rights to the script
RUN chmod +x /opt/script.sh

# Exposer le port 8080 utilisé par l'application
# Expose port 8080 used by the application
EXPOSE 8080

# Définir les variables d'environnement par défaut (seront surchargées par le script)
# Set default environment variables (will be overridden by the script)
ENV ODOO_URL=""
ENV PGADMIN_URL=""

# Lancer le script d'automatisation au démarrage
# Launch the automation script at startup
ENTRYPOINT ["sh", "/opt/script.sh"]
