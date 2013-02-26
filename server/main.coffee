YLEBEDEVA_ID = '12698906'

Content = new Meteor.Collection 'content'
Counters = new Meteor.Collection 'counters'

Meteor.publish 'content', () ->

    if @userId
        accessToken = Meteor.users.findOne(@userId)?.services?.instagram?.accessToken
        maxId = Counters.findOne({})?.maxId
        console.log "from counters -- maxId: #{maxId}"
        if maxId
            result = Meteor.http.get "https://api.instagram.com/v1/users/#{YLEBEDEVA_ID}/media/recent/?access_token=#{accessToken}?max_id={#maxId}"
        else
            result = Meteor.http.get "https://api.instagram.com/v1/users/#{YLEBEDEVA_ID}/media/recent/?access_token=#{accessToken}"

        cntIds = _.pluck(Content.find({}).fetch(), 'id')
        console.log "data ids -- cntIds: #{cntIds}"

        maxId = cntIds.sort()[0]
        console.log "from data -- maxId: #{maxId}"
        Counters.update {}, { $set: {maxId: maxId } }

        result.data?.data.forEach (c) ->
            if _.indexOf(cntIds, c.id) is -1
                try
                    Content.insert c
                catch e
                    # do nothing

    Content.find {}


Meteor.startup ->
    Content._ensureIndex 'id', { unique: 1, sparse: 1 }
    console.log "APP_START:: Application initialization started..."
    console.log "APP_START:: Application initialization finished..."
