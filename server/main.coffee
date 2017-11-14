import { Meteor } from 'meteor/meteor'
import { Mixpanel } from './lib/mixpanel'
import _ from 'underscore'

CONTENT_INITED = no
MAX_ID = 0
PAUSE_IN_MS = 1000
YLEBEDEVA_ID = 'ylebedeva'
CHROME_WIN_UA = 'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko)'+
                ' Chrome/59.0.3071.115 Safari/537.36'

Content = new Meteor.Collection 'content'
YLebedeva = new Meteor.Collection 'ylebedeva'
Max_Registered_Id = new Meteor.Collection 'maxid'

mixpanel = Mixpanel.init Meteor.settings.MIXPANEL_APIKEY, { debug: true }

fetchUserData = (user_id) ->
    result = Meteor.http.get "https://instagram.com/#{user_id}/media",
        { params: { 'user-agent': CHROME_WIN_UA } }
    
    console.log "INFO::INSTAGRAM API LIB:imgFetchUserData(): user profile:\n" +
                "#{JSON.stringify(result?.data)}"
    
    return result.data.items[0].user


downloadAndStoreContent = (user_id) ->
    exp_backoff = 1
    count_downloaded = 0
    count_inserted = 0
    done = false
    console.log 'INFO::downloadAndStoreContent: dowloading'

    while !done
        url = "https://instagram.com/#{user_id}/media"
        url = url + "?max_id=#{MAX_ID}" if MAX_ID isnt 0
        
        try
            result = Meteor.http.get url, { params: { 'user-agent': CHROME_WIN_UA } }
        catch e
            console.log "ERROR::downloadAndStoreContent:#{e}:backing off, #{2 ** exp_backoff - 1}s"
            exp_backoff = exp_backoff + 1
            process.exit(0) if exp_backoff is 5
            Meteor.sleep((2 ** exp_backoff - 1) * PAUSE_IN_MS)
            continue

        exp_backoff = 1

        continue unless result.data.items

        if result.data.items.length > 0
            items = result.data.items

            if items

                for c in items
                    _.extend c,
                        { mdfLikes: 0 }
                    if Content.find({ id: c.id }).count() is 0
                        Content.insert c
                        count_inserted = count_inserted + 1

                count_downloaded = count_downloaded + items.length
                MAX_ID = items[items.length - 1].id
                Max_Registered_Id.update Max_Registered_Id.findOne()._id, { id: MAX_ID }
                console.log count_downloaded, count_inserted
                Meteor.sleep(PAUSE_IN_MS)

        else
            done = true

    return {
        downloaded: count_downloaded,
        inserted: count_inserted
    }

validateData = () ->
    Content.find({}, { sort: { created_time: -1 } }).forEach (c) ->
        Meteor.http.get c.images.low_resolution.url, { params: { 'user-agent': CHROME_WIN_UA } },
            (err, result) ->
                if err
                    Content.update c._id, { $set: { deleted: yes } }
                else
                    Content.update c._id, { $set: { deleted: no } }

updateContentCollection = () ->
    count = downloadAndStoreContent(YLEBEDEVA_ID)
    validateData()
    cnt_deleted = Content.find({ deleted: yes }).count()
    console.log "INFO::UPDATE CONTENT: documents downloaded: #{count.downloaded},"+
                " documents inserted: #{count.inserted},"+
                " deleted content count: #{cnt_deleted}"

Meteor.publish 'content', (limit) ->
    Content.find { deleted: no }, { sort: { created_time: -1 }, limit: limit }

Meteor.publish 'ylebedeva', () ->
    YLebedeva.find {}

Meteor.methods {

    'update_db': () ->
        Max_Registered_Id.remove {}
        Max_Registered_Id.insert { id: 0 }
        MAX_ID = 0
        console.log "INFO::APP_START: Updating Instagram User Content Collection..."
        updateContentCollection()

    'track': (event, data) ->
        ## console.log "TRACK::#{event}: #{JSON.stringify data}"
        mixpanel.track event, data
}

Meteor.startup ->
    Content._ensureIndex 'id', { unique: 1, sparse: 1 }
    CONTENT_INITED = yes
    
###
    maxid = Max_Registered_Id.findOne({})

    if maxid
        MAX_ID = maxid.id
    else
        Max_Registered_Id.insert { id: 0 }

    if !YLebedeva.find({}).count()
        console.log "INFO::APP_START: Updating Instagram User Profile..."
        data = fetchUserData YLEBEDEVA_ID
        assert.ok(data, "ERROR::APP_START: Can't fetch user profile.")
        YLebedeva.insert data

    if Meteor.settings.INIT_CONTENT
        console.log "INFO::APP_START: Updating Instagram User Content Collection..."
        updateContentCollection()
###
