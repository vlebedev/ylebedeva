_paginator = (url, acc) ->
    result = Meteor.http.get url
    data = result?.data?.data
    next_url = result?.pagination?.next_url
    console.log result?.data?.meta
    console.log "media in batch: #{data?.length}, next_url: #{next_url}, next_max_id: #{result?.data?.pagination?.next_max_id}"
    acc.concat data if data
    if next_url then paginator(next_url, acc) else acc

fetchAllMediaArray = (user_id, access_token) ->
    first_batch = _paginator "https://api.instagram.com/v1/users/#{user_id}/media/recent/?access_token=#{access_token}", []
    console.log "media count: #{first_batch?.length}"
    
    if first_batch
        ts_sorted = first_batch.sort((a,b) -> a.created_time-b.created_time)
        max_id = ts_sorted[0].id
        console.log "media count: #{first_batch.length}, max_id: #{max_id}"
        _paginator "https://api.instagram.com/v1/users/#{user_id}/media/recent/?access_token=#{access_token}&max_id=#{max_id}", first_batch
    else
        []

