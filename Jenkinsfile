pipeline {
    agent any

    environment {
        // Nom de l'image Docker Hub (à adapter selon votre compte)
        // Docker Hub image name (to be adapted based on your account)
        DOCKER_IMAGE = "votre-login-docker/ic-webapp"
        
        // Identifiants Docker Hub stockés dans Jenkins
        // Docker Hub credentials stored in Jenkins
        DOCKER_HUB_CREDS = credentials('docker-hub-credentials')
    }

    stages {
        stage('Checkout') {
            steps {
                // Récupération du code depuis le repo
                // Checkout code from repository
                checkout scm
            }
        }

        stage('Build & Tag') {
            steps {
                script {
                    // Récupération de la version depuis releases.txt avec awk
                    // Retrieve version from releases.txt using awk
                    def appVersion = sh(script: "awk '/VERSION/ {print \$2}' releases.txt", returnStdout: true).trim()
                    echo "Building Version: ${appVersion}"
                    
                    // Build de l'image avec le tag dynamique
                    // Build the image with the dynamic tag
                    sh "docker build -t ${DOCKER_IMAGE}:${appVersion} ."
                    sh "docker tag ${DOCKER_IMAGE}:${appVersion} ${DOCKER_IMAGE}:latest"
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    // Test simple : vérifier que l'image a été créée
                    // Simple test: check if the image was created
                    sh "docker images | grep ${DOCKER_IMAGE}"
                    
                    // On pourrait ajouter un test de lancement ici
                    // We could add a launch test here
                    echo "Tests passés avec succès !"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    // Connexion et push de l'image
                    // Login and push the image
                    sh "echo ${DOCKER_HUB_CREDS_PSW} | docker login -u ${DOCKER_HUB_CREDS_USR} --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}:latest"
                    
                    def appVersion = sh(script: "awk '/VERSION/ {print \$2}' releases.txt", returnStdout: true).trim()
                    sh "docker push ${DOCKER_IMAGE}:${appVersion}"
                }
            }
        }

        stage('Deploy with Ansible') {
            steps {
                // Déploiement via le playbook Ansible qui appelle nos rôles
                // Deployment via the Ansible playbook calling our roles
                ansiblePlaybook(
                    playbook: 'ansible/deploy.yml',
                    inventory: 'ansible/hosts'
                )
            }
        }
    }

    post {
        always {
            // Nettoyage après le build
            // Cleaning up after the build
            echo "Pipeline terminé."
        }
    }
}
