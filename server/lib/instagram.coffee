_paginator = (url, acc) ->
    result = Meteor.http.get url
    data = result?.data?.data
    next_url = result?.pagination?.next_url
    console.log "data: #{result?.data}"
    console.log "len: #{data?.len}, next_url: #{next_url}"
    acc.concat data if data
    if next_url then paginator(next_url, acc) else acc

fetchAllMediaArray = (user_id, access_token) ->
    _paginator "https://api.instagram.com/v1/users/#{user_id}/media/recent/?access_token=#{access_token}", []

###
        if data
            existingCntIds = _.pluck Content.find({}).fetch(), 'id'
            resultTimeStamps = _.pluck(data, 'created_time').sort((a,b) -> a-b)

            minTS = resultTimeStamps[resultTimeStamps.length-1]
            maxTS = resultTimeStamps[0]

            console.log "from data -- minTS: #{minTS}, maxTS: #{maxTS}"
            Counters.update {}, { $set: {minTS: minTS, maxTS: maxTS } }
###
