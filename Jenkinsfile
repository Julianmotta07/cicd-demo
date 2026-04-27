pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/Julianmotta07/cicd-demo.git'
            }
        }

        stage('Build & Test') {
            steps {
                sh 'mvn clean package'
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
                                -Dsonar.login=sqp_a576f5bf1985b0f192dde84576d38619b04f18f2
                        '''
                    }
                }
            }
        }

        stage('Container Security Scan (Trivy)') {
            steps {
                sh 'trivy image --exit-code 1 --severity CRITICAL mi-app:latest'
            }
        }

        stage('Deploy') {
            when { branch 'main' }
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