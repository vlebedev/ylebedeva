YLEBEDEVA_ID = '12698906'

Content = new Meteor.Collection 'content'
Counters = new Meteor.Collection 'counters'

Meteor.publish 'content', () ->

    if @userId
        data        = []
        minTS       = null
        maxTS       = null
        resultMax   = null
        resultMin   = null
        accessToken = Meteor.users.findOne(@userId)?.services?.instagram?.accessToken
        counters    = Counters.findOne({})
        { minTS, maxTS } = counters if counters

        console.log "from mongo -- minTS: #{minTS}, maxTS: #{maxTS}"

        if minTS && maxTS
            resultMax = Meteor.http.get "https://api.instagram.com/v1/users/#{YLEBEDEVA_ID}/media/recent/?access_token=#{accessToken}&max_timestamp={#maxTS}"
            resultMin = Meteor.http.get "https://api.instagram.com/v1/users/#{YLEBEDEVA_ID}/media/recent/?access_token=#{accessToken}&min_timestamp={#minTS}"
            console.log "================"
            console.log resultMax?.data
            console.log "================"
            console.log resultMin?.data
        else
            Counters.insert { minTS: '', maxTS: '' }
            result = Meteor.http.get "https://api.instagram.com/v1/users/#{YLEBEDEVA_ID}/media/recent/?access_token=#{accessToken}"

        if resultMax or resultMin
            if resultMax.data?.data
                data = resultMax.data.data
            if resultMin.data?.data
                data = data.concat resultMin.data.data
        else
            data = result?.data?.data

        console.log data

        if data
            existingCntIds = _.pluck Content.find({}).fetch(), 'id'
            resultTimeStamps = _.pluck(data, 'created_time').sort((a,b) -> a-b)

            console.log "time stamps sorted -- resultTimeStamps: #{resultTimeStamps}"

            minTS = resultTimeStamps[resultTimeStamps.length-1]
            maxTS = resultTimeStamps[0]

            console.log "from data -- minTS: #{minTS}, maxTS: #{maxTS}"
            Counters.update {}, { $set: {minTS: minTS, maxTS: maxTS } }

            data.forEach (c) ->
                if _.indexOf(existingCntIds, c.id) is -1
                    try
                        Content.insert c
                    catch e
                        # do nothing

    Content.find {}


Meteor.startup ->
    Content._ensureIndex 'id', { unique: 1, sparse: 1 }
    console.log "APP_START:: Application initialization started..."
    console.log "APP_START:: Application initialization finished..."
