YLEBEDEVA_ID = '12698906'

Content = new Meteor.Collection 'content'
Counters = new Meteor.Collection 'counters'

Meteor.publish 'content', () ->

    if @userId

        accessToken = Meteor.users.findOne(@userId)?.services?.instagram?.accessToken
        data = fetchAllMediaArray YLEBEDEVA_ID, accessToken
        existingCntIds = _.pluck Content.find({}, { fields: { id: 1 } }).fetch(), 'id'

        if data
            data.forEach (c) ->
                if _.indexOf(existingCntIds, c.id) is -1
                    console.log "new content id: #{c.id}"
                    try
                        Content.insert c
                    catch e
                        # do nothing
                else
                    console.log "existing content id: #{c.id}"

    Content.find {}


Meteor.startup ->
    Content._ensureIndex 'id', { unique: 1, sparse: 1 }
    console.log "APP_START:: Application initialization started..."
    console.log "APP_START:: Application initialization finished..."
