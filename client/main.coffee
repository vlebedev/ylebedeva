Content = new Meteor.Collection 'content'

Meteor.autorun ()->
    Meteor.subscribe 'content'

Meteor.startup ->
    Meteor.subscribe 'content'