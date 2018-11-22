#!groovy

node('master') {
    stage('Checkout repository') {
        checkout scm
    }
    stage('Build') {
        sh 'make build'
    }
    stage('Test: static') {
        sh 'bash tests/validator/validator-new-test.sh'
    }
    if (env.BRANCH_NAME == 'master' || env.BRANCH_NAME == 'devel') {
        stage('Create artifact') {
            sh 'make distrib'
            archive 'distrib/openagh-parser.tar.gz'
        }
    }
}
