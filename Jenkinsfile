#! /usr/bin/groovy

pipeline {
    agent any 
    
    options {
        disableConcurentBuilds()
    }

    stages {
        stage("Build") {
            steps {
                buildApp()
            }
        }

        stage("Deploy-Dev") {
            steps {
                deploy('dev')
            }
        }
     }
}