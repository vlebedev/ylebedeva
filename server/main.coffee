CONTENT_INITED = no
YLEBEDEVA_ID = '12698906'
ACCESS_TOKEN = '4695387.85184ee.a442ae2228dd494794aa5271e960b7ad'

Content = new Meteor.Collection 'content'
YLebedeva = new Meteor.Collection 'ylebedeva'

mixpanel = Mixpanel.init Meteor.settings.MIXPANEL_APIKEY, debug: true

validateData = () ->
    Content.find({}, { sort: { created_time: -1 } }).forEach (c) ->
        Meteor.http.get c.images.low_resolution.url, 
            (err, result) ->
                if err
                    Content.update c._id,
                        $set:
                            deleted: yes
                else
                    Content.update c._id,
                        $set:
                            deleted: no

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

updateContentCollection = (accessToken) ->
    # Content.remove({})
    count = insertData igmFetchAllMediaArray YLEBEDEVA_ID, accessToken
    validateData()
    cnt_deleted = Content.find({ deleted: yes }).count()
    console.log "INFO::UPDATE CONTENT: documents inserted: #{count}, deleted content count: #{cnt_deleted}"

Meteor.publish 'content', (limit) ->
    if @userId
        accessToken = Meteor.users.findOne(@userId)?.services?.instagram?.accessToken
        console.log "INFO::PUBLISH CONTENT: access_token: #{accessToken}" if Meteor.settings.INIT_CONTENT

        if !CONTENT_INITED and Meteor.settings.INIT_CONTENT and (process.env.ROOT_URL.indexOf('localhost') is -1)
            console.log "INFO::PUBLISH CONTENT: Updating PRODUCTION Content Collection..."
            updateContentCollection accessToken
            CONTENT_INITED = yes

        if !YLebedeva.find({}).count() and (process.env.ROOT_URL.indexOf('localhost') is -1)
            data = igmFetchUserData YLEBEDEVA_ID, accessToken
            YLebedeva.insert data if data

    Content.find { deleted: no }, { sort: { created_time: -1 }, limit: limit }

Meteor.publish 'ylebedeva', () ->
    YLebedeva.find {}

Meteor.methods 

    'update_db': () ->
        if Meteor.user()
            accessToken = Meteor.user()?.services?.instagram?.accessToken
            updateContentCollection accessToken

    'track': (event, data) ->
        console.log "TRACK::#{event}: #{JSON.stringify data}"
        mixpanel.track event, data

Meteor.startup ->
    Content._ensureIndex 'id', { unique: 1, sparse: 1 }

    if !YLebedeva.find({}).count() and (process.env.ROOT_URL.indexOf('localhost') isnt -1)
        data = igmFetchUserData YLEBEDEVA_ID, ACCESS_TOKEN
        YLebedeva.insert data if data

    if Meteor.settings.INIT_CONTENT and (process.env.ROOT_URL.indexOf('localhost') isnt -1)
        console.log "INFO::APP_START: Updating LOCAL Content Collection..."
        updateContentCollection ACCESS_TOKEN
        CONTENT_INITED = yes
