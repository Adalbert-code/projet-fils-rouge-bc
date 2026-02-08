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
        stage('CODE - Checkout') {
            steps {
                checkout scm
            }
        }

        stage('BUILD - Build & Tag') {
            steps {
                script {
                    def appVersion = sh(script: "awk '/VERSION/ {print \$2}' releases.txt", returnStdout: true).trim()
                    echo "Building Version: ${appVersion}"
                    sh "docker build -t ${DOCKER_IMAGE}:${appVersion} ."
                    sh "docker tag ${DOCKER_IMAGE}:${appVersion} ${DOCKER_IMAGE}:latest"
                }
            }
        }

        stage('CODE QUALITY - Linting') {
            steps {
                script {
                    echo "Running Code Quality checks with flake8..."
                    // On installe flake8 si nécessaire ou on utilise une image avec flake8
                    sh "pip install flake8 && flake8 --ignore=E501 app.py"
                }
            }
        }

        stage('TESTS - Functional') {
            steps {
                script {
                    echo "Running comprehensive functional tests..."
                    
                    // Test 1: Vérifier que l'image existe
                    // Test 1: Verify image exists
                    sh "docker images | grep ${DOCKER_IMAGE}"
                    
                    // Test 2: Lancer un conteneur de test
                    // Test 2: Launch a test container
                    def appVersion = sh(script: "awk '/VERSION/ {print \$2}' releases.txt", returnStdout: true).trim()
                    sh """
                        docker run -d --name test-ic-webapp \
                            -e ODOO_URL=https://www.odoo.com/ \
                            -e PGADMIN_URL=https://www.pgadmin.org/ \
                            -p 8081:8080 \
                            ${DOCKER_IMAGE}:${appVersion}
                    """
                    
                    // Test 3: Attendre le démarrage de l'application
                    // Test 3: Wait for application startup
                    sleep(time: 10, unit: 'SECONDS')
                    
                    // Test 4: Vérifier que l'application répond
                    // Test 4: Verify application responds
                    sh """
                        curl -f http://localhost:8081 || (docker logs test-ic-webapp && exit 1)
                    """
                    
                    echo "✓ Tests fonctionnels passés avec succès !"
                }
            }
            post {
                always {
                    // Nettoyage du conteneur de test
                    // Cleanup test container
                    sh """
                        docker stop test-ic-webapp || true
                        docker rm test-ic-webapp || true
                    """
                }
            }
        }

        stage('PACKAGE - Push to Docker Hub') {
            steps {
                script {
                    sh "echo ${DOCKER_HUB_CREDS_PSW} | docker login -u ${DOCKER_HUB_CREDS_USR} --password-stdin"
                    sh "docker push ${DOCKER_IMAGE}:latest"
                    
                    def appVersion = sh(script: "awk '/VERSION/ {print \$2}' releases.txt", returnStdout: true).trim()
                    sh "docker push ${DOCKER_IMAGE}:${appVersion}"
                }
            }
        }

        stage('CD - REVIEW/TEST') {
            steps {
                input message: "Approuver le déploiement en PRODUCTION ?", ok: "Déployer"
            }
        }

        stage('CD - PRODUCTION') {
            steps {
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
