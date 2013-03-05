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
        cid = Session.get 'current_content'
        Router.setMain 'matrix'
        setTimeout( 
            () ->
                $(window).scrollTo('#'+"#{cid}", 300, { offset: {top: -278, left: 0 } })
            , 500
        )

    'click .like-button': (evt) ->
        if !Session.get 'liked'
            Session.set 'liked', 'liked'
            cid = Session.get 'current_content'
            content = Content.findOne(cid)
            Content.update cid,
                $inc:
                    mdfLikes: 1
            Meteor.call 'track', 'like',
                id: content.id
                image_url: content.images.low_resolution.url

