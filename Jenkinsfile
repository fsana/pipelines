#! /usr/bin/groovy


pipeline {
    agent any 
    
    options {
        disableConcurrentBuilds()
    }

    environment {
        PYTHONPATH = "${WORKSPACE}"
    }

    stages {
        stage ("Test - Unit Tests") {
            steps {
                runUnitTests()
            }
        }
        stage("Build") {
            steps {
                buildApp()
            }
        }

        stage("Deploy - Dev") {
            steps {
                deploy('dev')
            }
        }

        stage("Test - UAT Dev") {
            steps {
                runUAT(8888)
            }
        }

        stage("Deploy - Stage") {
            steps {
                deploy('stage')
            }
        }

        stage("Test - UAT Stage") {
            steps {
                runUAT(8889)
            }
        }

        stage("Approve") {
            steps {
                approve()
            }
        }

        stage("Deploy - Live") {
            steps {
                deploy('live')
            }
        }

        stage("Test - UAT Live") {
            steps {
                runUAT(8890)
            }
        }
     }
}

def approve() {
    timeout(time: 1, unit: 'DAYS') {
        input('Do you want to deploy to live environment?')
    }
}

def runUnitTests() {
    sh "pip3 install --no-cache-dir -r requirements.txt"
    sh "python3 tests/test_flask_app.py"
}

def runUAT(port) {
    sh "tests/runUAT.sh ${port}"
}

def buildApp() {
    def appImage = docker.build("fsana/my-app:${BUILD_NUMBER}")
}

def deploy(environment) {
    def containerName = ''
    def port = ''
    if ("${environment}"=='dev') {
        containerName = "app_dev"
        port = "8888"
    } else if ("${environment}" == 'stage') {
        containerName = "app_stage"
        port = "8889"
    } else if ("${environment}" == 'live') {
        containerName = "app_live"
        port = "8890"
    }
    else {
        println "Environment not valid"
        System.exit(0)
    }

    sh "docker ps -f name=${containerName} -q | xargs --no-run-if-empty docker stop"
    sh "docker ps -a -f name=${containerName} -q | xargs -r docker rm"
    sh "docker run -d -p ${port}:5000 --name ${containerName} fsana/my-app:${BUILD_NUMBER}" 
 }