#!/usr/bin/env groovy

pipeline {
    agent any
    environment {
        HEROKU_API_KEY = 'THIS STRING IS NOT AN API KEY'
    }
    stages {
        stage('test') {
            steps {
                sh './test.sh'
            }
        }
    }
}
