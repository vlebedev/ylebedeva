{spawn, exec} = require 'child_process'
fs = require 'fs'

task 'run', 'run project in local mode', (options) =>
    process.env.MONGO_URL = "mongodb://localhost:27017/ylebedeva"
    spawn 'meteor', ['run', '--settings', './settings.json'],
        stdio: 'inherit'
        env: process.env

task 'deploy', 'deploy application to Meteor Galaxy', (options) =>
    console.log 'Deploying application to Meteor Galaxy...'
    process.env.DEPLOY_HOSTNAME="galaxy.meteor.com"
    spawn 'meteor', ['deploy', 'ylebedeva.meteorapp.com', '--settings', './settings.json'], 
        stdio: 'inherit'
        env: process.env
