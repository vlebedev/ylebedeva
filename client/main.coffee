Content = new Meteor.Collection 'content'
YLebedeva = new Meteor.Collection 'ylebedeva'

Meteor.autorun ()->
    Meteor.subscribe 'content'
    Meteor.subscribe 'ylebedeva'

Meteor.startup ->
    Session.setDefault 'current_content', null
