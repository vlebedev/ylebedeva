{spawn, exec} = require 'child_process'
fs = require 'fs'

task 'run', 'run project in local mode', (options) =>
    process.env.MONGO_URL = "mongodb://localhost:27017/ylebedeva"
    spawn 'mrt', ['--settings', './settings.json'],
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

task 'config', 'change configuration settings on the PRODUCTION app', (options) =>
    console.log 'Deploying new CONFIGURATION to PRODUCTION environment...'
    settings = fs.readFileSync './settings.json', 'utf8'
    settings = settings.replace /"/g, '\\'+'"'
    exec "heroku config:set METEOR_SETTINGS=\"#{settings}\" --app ylebedeva", (err, stdin, stdout) ->
        console.log stdout