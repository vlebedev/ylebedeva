_paginator = (url, acc) ->
    result = Meteor.http.get url
    data = result?.data?.data
    next_url = result?.data?.pagination?.next_url
    console.log "INFO::INSTAGRAM API LIB:_paginator(): media in batch: #{data?.length}, next_max_id: #{result?.data?.pagination?.next_max_id}"
    acc = acc.concat data if data
    if next_url then _paginator(next_url, acc) else acc

igmFetchAllMediaArray = (user_id, access_token) ->
    _paginator "https://api.instagram.com/v1/users/#{user_id}/media/recent/?access_token=#{access_token}&count=-1", []

igmFetchNewMediaArray = (user_id, access_token, min_id) ->
    _paginator "https://api.instagram.com/v1/users/#{user_id}/media/recent/?access_token=#{access_token}&min_id=#{min_id}&count=-1", []

igmFetchUserData = (user_id, access_token) ->
    result = Meteor.http.get "https://api.instagram.com/v1/users/#{user_id}/?access_token=#{access_token}"
    console.log result?.data
    result?.data?.data
