CONTENT_INITED = no
YLEBEDEVA_ID = '12698906'
ACCESS_TOKEN = '4695387.85184ee.a442ae2228dd494794aa5271e960b7ad'

Content = new Meteor.Collection 'content'
Counters = new Meteor.Collection 'counters'

insertData = (data) ->
    cnt = 0
    if data
        existingCntIds = _.pluck Content.find({}, { fields: { id: 1 } }).fetch(), 'id'
        data.forEach (c) ->
            if _.indexOf(existingCntIds, c.id) is -1
                try
                    Content.insert c
                    cnt += 1
                catch e
                    # do nothing
        return cnt
    else
        0

initializeContentCollection = (accessToken) ->
    Content.remove({})
    count = insertData fetchAllMediaArray YLEBEDEVA_ID, accessToken
    console.log "INFO::INIT CONTENT: documents inserted: #{count}"

updateContentCollection = (accessToken) ->
    min_id = Content.find({}, { sort: { created_time: -1 } }).fetch()?[0].id
    count = insertData fetchNewMediaArray YLEBEDEVA_ID, accessToken, min_id
    console.log "INFO::UPDATE CONTENT: documents inserted: #{count}"

Meteor.publish 'content', () ->
    if @userId
        accessToken = Meteor.users.findOne(@userId)?.services?.instagram?.accessToken
        console.log "INFO::PUBLISH CONTENT: access_token: #{accessToken}"

        if !CONTENT_INITED and Meteor.settings.INIT_CONTENT and (process.env.ROOT_URL.indexOf('localhost') is -1)
            console.log "INFO::PUBLISH CONTENT: Initializing PRODUCTION Content Collection..."
            initializeContentCollection accessToken
            CONTENT_INITED = yes

        updateContentCollection accessToken

    Content.find {}

Meteor.startup ->

    console.log "INFO::APP_START: Application initialization started..."
    Content._ensureIndex 'id', { unique: 1, sparse: 1 }

    if Meteor.settings.INIT_CONTENT and (process.env.ROOT_URL.indexOf('localhost') isnt -1)
        console.log "INFO::APP_START: Initializing LOCAL Content Collection..."
        initializeContentCollection ACCESS_TOKEN
        CONTENT_INITED = yes

    console.log "INFO::APP_START: Application initialization finished..."
