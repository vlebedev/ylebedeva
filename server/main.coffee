CONTENT_INITED = no
LAST_UPDATE = 0
YLEBEDEVA_ID = '12698906'
ACCESS_TOKEN = '4695387.85184ee.a442ae2228dd494794aa5271e960b7ad'

Content = new Meteor.Collection 'content'
YLebedeva = new Meteor.Collection 'ylebedeva'

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
    count = insertData igmFetchAllMediaArray YLEBEDEVA_ID, accessToken
    console.log "INFO::INIT CONTENT: documents inserted: #{count}"

updateContentCollection = (accessToken) ->
    tm = Date.utc.create().getTime()
    count = 0
    if tm - LAST_UPDATE >= (1000*60*5)
        min_id = Content.find({}, { sort: { created_time: -1 } }).fetch()?[0].id
        count = insertData igmFetchNewMediaArray YLEBEDEVA_ID, accessToken, min_id
        console.log "INFO::UPDATE CONTENT: documents inserted: #{count}"
        LAST_UPDATE = tm
    return count

Meteor.publish 'content', () ->
    if @userId
        accessToken = Meteor.users.findOne(@userId)?.services?.instagram?.accessToken
        console.log "INFO::PUBLISH CONTENT: access_token: #{accessToken}" if Meteor.settings.INIT_CONTENT

        if !CONTENT_INITED and Meteor.settings.INIT_CONTENT and (process.env.ROOT_URL.indexOf('localhost') is -1)
            console.log "INFO::PUBLISH CONTENT: Initializing PRODUCTION Content Collection..."
            initializeContentCollection accessToken
            CONTENT_INITED = yes

        if !YLebedeva.find({}).count() and (process.env.ROOT_URL.indexOf('localhost') is -1)
            data = igmFetchUserData YLEBEDEVA_ID, accessToken
            YLebedeva.insert data if data

        updateContentCollection accessToken

    Content.find {}, { limit: 60 }

Meteor.publish 'ylebedeva', () ->
    YLebedeva.find {}

Meteor.startup ->

    console.log "INFO::APP_START: Application initialization started..."
    Content._ensureIndex 'id', { unique: 1, sparse: 1 }

    if !YLebedeva.find({}).count() and (process.env.ROOT_URL.indexOf('localhost') isnt -1)
        data = igmFetchUserData YLEBEDEVA_ID, ACCESS_TOKEN
        YLebedeva.insert data if data

    if Meteor.settings.INIT_CONTENT and (process.env.ROOT_URL.indexOf('localhost') isnt -1)
        console.log "INFO::APP_START: Initializing LOCAL Content Collection..."
        initializeContentCollection ACCESS_TOKEN
        CONTENT_INITED = yes

    console.log "INFO::APP_START: Application initialization finished..."
