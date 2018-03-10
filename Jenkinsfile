#!/usr/bin/env groovy

pipeline {
    agent any
    environment {
        HEROKU_TOKEN = credentials('HEROKU_TOKEN')
    }
    stages {
        stage('test') {
            steps {
                sh './test.sh'
            }
        }
    }
}
