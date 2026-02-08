#!/bin/sh

# Extraire les URLs du fichier releases.txt en utilisant awk
# Extract URLs from releases.txt file using awk
export ODOO_URL=$(awk '/ODOO_URL/ {print $2}' releases.txt)
export PGADMIN_URL=$(awk '/PGADMIN_URL/ {print $2}' releases.txt)

# Afficher les variables pour vérification (optionnel)
# Display variables for verification (optional)
echo "Odoo URL: $ODOO_URL"
echo "PgAdmin URL: $PGADMIN_URL"

# Lancer l'application python
# Start the python application
python app.py
