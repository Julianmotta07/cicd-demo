pipeline {
    agent any

    tools {
        maven 'Maven-3.9.9'
        jdk 'JDK-21'
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Julianmotta07/cicd-demo.git'
            }
        }

        stage('Build & Test') {
            steps {
                sh 'mvn clean package -Dmaven.test.skip=true'
            }
        }

        stage('Docker Build') {
            steps {
                sh 'docker build -t mi-app:latest .'
            }
        }

        stage('Static Analysis (SonarQube)') {
            steps {
                script {
                    withSonarQubeEnv('SonarQube') {
                        sh '''
                            mvn sonar:sonar \
                                -Dsonar.projectKey=my-app \
                                -Dsonar.login=${SONAR_TOKEN}
                        '''
                    }
                }
            }
        }

        stage('Container Security Scan (Trivy)') {
            steps {
                sh 'trivy image --timeout 20m --skip-version-check --exit-code 0 --severity CRITICAL mi-app:latest'
            }
        }

        stage('Deploy') {
            steps {
                sh 'docker run -d -p 80:80 mi-app:latest'
            }
        }
    }

    post {
        always {
            echo 'Limpiando entorno...'
            cleanWs()
        }
        failure {
            echo 'El pipeline falló. Revisa los logs.'
        }
    }
}