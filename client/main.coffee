Content = new Meteor.Collection 'content'
YLebedeva = new Meteor.Collection 'ylebedeva'

Meteor.autorun ->
    Meteor.subscribe 'content', Session.get('content_limit'), () ->
        Session.set 'loading', no
        console.log "requesting new limit: #{Session.get 'content_limit'}"
    Meteor.subscribe 'ylebedeva'

YLRouter = Backbone.Router.extend

    routes: 
        'matrix': 'matrix'
        'photo/:id': 'photo'
        'EnablESigNin': 'enable'
        'updateDB': 'update'

    photo: (id) ->
        Session.set 'current_content', id
        Session.set 'prev_content', null

    matrix: () ->
        Session.set 'current_content', null
        Session.set 'prev_content', null

    enable: () ->
        Session.set 'enable_signin', yes
        @navigate 'matrix', true

    update: () ->
        Meteor.call 'update_db'
        @navigate 'matrix', true

    setMain: (page) ->
        @navigate page, true

Router = new YLRouter

Meteor.startup ->
    Session.setDefault 'current_content', null
    Session.setDefault 'prev_content', null
    Session.setDefault 'content_limit', 30
    Session.setDefault 'loading', no
    Session.setDefault 'liked', ''
    Session.setDefault 'enable_signin', no
    Backbone.history.start pushState: true
