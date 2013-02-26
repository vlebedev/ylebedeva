YLEBEDEVA_ID = '12698906'

Content = new Meteor.Collection 'content'

Meteor.publish 'content', () ->

    if @userId
        accessToken = Meteor.users.findOne(@userId)?.services?.instagram?.accessToken
        result = Meteor.http.get "https://api.instagram.com/v1/users/#{YLEBEDEVA_ID}/media/recent/?access_token=#{accessToken}"
        console.log result.data?.data

        cntIds = _.pluck(Content.find({}).fetch(), 'id')
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
