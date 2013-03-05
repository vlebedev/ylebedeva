CONTENT_INITED = no
YLEBEDEVA_ID = '12698906'
ACCESS_TOKEN = '4695387.85184ee.a442ae2228dd494794aa5271e960b7ad'

Content = new Meteor.Collection 'content'
YLebedeva = new Meteor.Collection 'ylebedeva'

mixpanel = Mixpanel.init Meteor.settings.MIXPANEL_APIKEY, debug: true

insertData = (data) ->
    cnt = 0
    if data
        existingCntIds = _.pluck Content.find({}, { fields: { id: 1 } }).fetch(), 'id'
        data.forEach (c) ->
            if _.indexOf(existingCntIds, c.id) is -1
                _.extend c,
                    mdfLikes: 0
                try
                    Content.insert c
                    cnt += 1
                catch e
                    # do nothing
        return cnt
    else
        0

initializeContentCollection = (accessToken) ->
    # Content.remove({})
    count = insertData igmFetchAllMediaArray YLEBEDEVA_ID, accessToken
    console.log "INFO::INIT CONTENT: documents inserted: #{count}"
    # apply patches
    console.log "INFO::INIT CONTENT: patching content..."
    Content.remove { id: "358128846454459696_12698906" }
    Content.remove { id: "311775728188067002_12698906" }

updateContentCollection = (accessToken) ->
    count = 0
    min_id = Content.find({}, { sort: { created_time: -1 } }).fetch()?[0].id
    count = insertData igmFetchNewMediaArray YLEBEDEVA_ID, accessToken, min_id
    console.log "INFO::UPDATE CONTENT: documents inserted: #{count}"
    return count

Meteor.publish 'content', (limit) ->
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

    Content.find {}, { sort: { created_time: -1 }, limit: limit }

Meteor.publish 'ylebedeva', () ->
    YLebedeva.find {}

Meteor.methods 
    
    'updated_db': () ->
        if Meteor.user()
            accessToken = Meteor.user()?.services?.instagram?.accessToken
            updateContentCollection accessToken

    'track': (event, data) ->
        console.log "TRACK::#{event}: #{JSON.stringify data}"
        mixpanel.track event, data

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
