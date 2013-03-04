Content = new Meteor.Collection 'content'
YLebedeva = new Meteor.Collection 'ylebedeva'

Meteor.autorun ()->
    Meteor.subscribe 'content', Session.get('content_limit'), () ->
        Session.set 'loading', no
        console.log "requesting new limit: #{Session.get 'content_limit'}"
    Meteor.subscribe 'ylebedeva'

Meteor.startup ->
    Session.setDefault 'current_content', null
    Session.setDefault 'content_limit', 15
    Session.setDefault 'loading', no

