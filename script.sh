#!/bin/sh

# Arrêter en cas d'erreur
# Stop on error
set -e

# Vérifier que releases.txt existe
# Check if releases.txt exists
if [ ! -f releases.txt ]; then
    echo "ERROR: releases.txt not found!"
    exit 1
fi

# Extraire les URLs du fichier releases.txt en utilisant awk
# Extract URLs from releases.txt file using awk
export ODOO_URL=$(awk '/ODOO_URL/ {print $2}' releases.txt)
export PGADMIN_URL=$(awk '/PGADMIN_URL/ {print $2}' releases.txt)

# Validation des variables
# Validate variables
if [ -z "$ODOO_URL" ] || [ -z "$PGADMIN_URL" ]; then
    echo "ERROR: URLs not properly extracted from releases.txt"
    echo "ODOO_URL: $ODOO_URL"
    echo "PGADMIN_URL: $PGADMIN_URL"
    exit 1
fi

# Afficher les variables pour vérification
# Display variables for verification
echo "✓ Odoo URL: $ODOO_URL"
echo "✓ PgAdmin URL: $PGADMIN_URL"
echo "Starting application..."

# Lancer l'application python
# Start the python application
python app.py
