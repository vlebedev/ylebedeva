import { Meteor } from 'meteor/meteor'
import { Mixpanel } from './lib/mixpanel'
import _ from 'underscore'

Content = new Meteor.Collection 'content'
YLebedeva = new Meteor.Collection 'ylebedeva'

mixpanel = Mixpanel.init Meteor.settings.MIXPANEL_APIKEY, { debug: true }

Meteor.publish 'content', (limit) ->
    Content.find { deleted: no }, { sort: { taken_at_timestamp: -1 }, limit: limit }

Meteor.publish 'ylebedeva', () ->
    YLebedeva.find {}

Meteor.methods {
    'track': (event, data) ->
        ## console.log "TRACK::#{event}: #{JSON.stringify data}"
        mixpanel.track event, data
}

Meteor.startup ->
    console.log "INFO::APP_START: Backend is starting..."
    
    Content._ensureIndex 'id', { unique: 1, sparse: 1 }

    # Clean the database
    Content.remove {}
    YLebedeva.remove {}

    # Fetch and store user profile
    result = Meteor.http.get 'https://ylebedeva-api.now.sh/profile'
    assert.ok result.data, "ERROR::APP_START: Can't fetch user profile."
    YLebedeva.insert result.data

    console.log "INFO::APP_START: Successfully stored user profile in the database."

    # Fetch and store content
    result = Meteor.http.get 'https://ylebedeva-api.now.sh/media'
    assert.ok result.data, "ERROR::APP_START: Can't fetch media."

    for media in result.data
        _.extend media, {
            mdfLikes: 0,
            deleted: no
        }
        Content.insert media

    console.log "INFO::APP_START: Successfully stored #{Content.find({}).count()}" +
                " media nodes in the database."
    
    console.log "INFO::APP_START: Backend is ready!"
