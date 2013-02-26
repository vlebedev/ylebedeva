Content = new Meteor.Collection 'content'

Meteor.autorun ()->
    Meteor.subscribe 'content'

Meteor.startup ->
    console.log "hello, world!"