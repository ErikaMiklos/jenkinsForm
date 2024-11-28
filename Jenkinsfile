pipeline {
    agent any 

    tools {
        maven 'Maven 3.8.1'
    }

    environment {
        DOCKER_IMAGE = "vanessakovalsky/mon-application-java"
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        registryCredential = 'docker'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', 
                    url: 'https://github.com/vanessakovalsky/demo-java.git'
            }
        }


        stage('Build') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }

        // stage('Package') {
        //     steps {
        //         sh 'mvn package -DskipTests=true'
        //     }
        // }

        stage('Build Docker Image') {
            steps {
                script {
                    // Construction de l'image Docker
                    dockerImage = docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                }
            }
        }
        stage('Push Image') {
            steps{
                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push("$BUILD_NUMBER")
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                // Exemple de déploiement (à adapter)
                sh 'echo "Déploiement du projet"'
            }
        }
    }

    post {
        success {
            // archiveArtifacts artifacts: 'target/*.jar', 
            //                  fingerprint: true
            
            emailext (
                subject: "Build Réussi: ${currentBuild.fullDisplayName}",
                body: "Le build a été effectué avec succès.",
                to: 'equipe@exemple.com'
            )
        }
        
        failure {
            emailext (
                subject: "Build Échoué: ${currentBuild.fullDisplayName}",
                body: "Le build a échoué. Veuillez vérifier les logs.",
                to: 'equipe@exemple.com'
            )
        }
    }
}
