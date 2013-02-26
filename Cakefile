{spawn, exec} = require 'child_process'
fs = require 'fs'

task 'run', 'run project in local mode', (options) =>
    process.env.MONGO_URL = "mongodb://localhost:27017/ylebedeva"
    spawn 'mrt', [],
        stdio: 'inherit'
        env: process.env

task 'pull', 'pull database from heroku to local machine', (options) =>
    process.env.MONGO_URL = "mongodb://localhost:27017/ylebedeva"
    spawn 'heroku', ['mongo:pull', '--app', 'ylebedeva'], 
        stdio: 'inherit'
        env: process.env

task 'deploy', 'deploy DEVELOP branch to ylebedeva app on heroku', (options) =>
    console.log 'Deploying application from **develop** branch...'
    spawn 'git', ['push', 'heroku', 'develop:master'], 
        stdio: 'inherit'
        env: process.env
