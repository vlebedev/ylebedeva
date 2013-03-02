CONTENT_INITED = no
YLEBEDEVA_ID = '12698906'
ACCESS_TOKEN = '4695387.85184ee.a442ae2228dd494794aa5271e960b7ad'

Content = new Meteor.Collection 'content'
Counters = new Meteor.Collection 'counters'

initializeContentCollection = () ->
    Content.remove({})

    if process.env.ROOT_URL.indexOf('localhost') isnt -1
        accessToken = ACCESS_TOKEN
    else
        accessToken = Meteor.users.findOne(@userId)?.services?.instagram?.accessToken
        console.log "INFO::INIT CONTENT: access_token: #{accessToken}"

    data = fetchAllMediaArray YLEBEDEVA_ID, accessToken
    existingCntIds = _.pluck Content.find({}, { fields: { id: 1 } }).fetch(), 'id'

    if data
        data.forEach (c) ->
            if _.indexOf(existingCntIds, c.id) is -1
                try
                    Content.insert c
                catch e
                    # do nothing
            else


Meteor.publish 'content', () ->
    if !CONTENT_INITED and Meteor.settings.INIT_CONTENT and (process.env.ROOT_URL.indexOf('localhost') is -1)
        console.log "INFO::PUBLISH CONTENT: Initializing PRODUCTION Content Collection..."
        initializeContentCollection()
        CONTENT_INITED = yes

    Content.find {}

Meteor.startup ->

    console.log "INFO::APP_START: Application initialization started..."
    Content._ensureIndex 'id', { unique: 1, sparse: 1 }

    if Meteor.settings.INIT_CONTENT and (process.env.ROOT_URL.indexOf('localhost') isnt -1)
        console.log "INFO::APP_START: Initializing LOCAL Content Collection..."
        initializeContentCollection()
        CONTENT_INITED = yes

    console.log "INFO::APP_START: Application initialization finished..."
