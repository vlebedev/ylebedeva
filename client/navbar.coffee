_.extend Template.navbar,

    liked: () ->
        Session.get 'liked'

    likes_counter: () ->
        _id = Session.get 'current_content'
        if _id
            likes = Content.findOne(_id)?.mdfLikes
            if likes
                return "(#{likes})"
        return ''

    show_sign_in_button: () ->
        Session.get 'enable_signin'

    userpic: () ->
        YLebedeva.findOne({})?.profile_picture

    current_content: () ->
        Session.get 'current_content'

    rendered: () ->
        if Session.get 'enable_signin'
            $('.text-besides-image').text('Sign In').css({ 'font-size': 36, 'font-family': 'BillabongRegular'})
            $('#login-buttons').css({ 'padding-top': '27px' })
            $('.login-button').css({ 'border': 'none' })
            $('#login-buttons-logout').css({ 'font-size': 36, 'font-family': 'BillabongRegular'})
            $('.login-display-name').text(Meteor.user()?.profile.name).css({ 'font-size': 20, 'color': '#FFFFFF' })

        prev = Session.get 'prev_content'
        curr = Session.get 'current_content'
        if prev isnt curr
            Session.set 'liked', ''
            Session.set 'prev_content', curr

Template.navbar.events

    'click .brand': (evt) ->
        evt.preventDefault()
        Session.set 'current_content', null

    'click .like-button': (evt) ->
        if !Session.get 'liked'
            Session.set 'liked', 'liked'
            Content.update Session.get('current_content'),
                $inc:
                    mdfLikes: 1

