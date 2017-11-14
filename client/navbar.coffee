Template.navbar.helpers {

    liked: () ->
        Session.get 'liked'

    likes_counter: () ->
        _id = Session.get 'current_content'
        if _id
            likes = share.Content.findOne(_id)?.mdfLikes
            if likes
                return "(#{likes})"
        return ''

    show_sign_in_button: () ->
        Session.get 'enable_signin'

    userpic: () ->
        share.YLebedeva.findOne({})?.profile_pic_url

    current_content: () ->
        Session.get 'current_content'
}

Template.navbar.onRendered () ->
    if Session.get 'enable_signin'
        $('.text-besides-image').text('Sign In').css({
            'font-size': 36,
            'font-family': 'BillabongRegular' })
        $('#login-buttons').css({ 'padding-top': '27px' })
        $('.login-button').css({ 'border': 'none' })
        $('#login-buttons-logout').css({ 'font-size': 36, 'font-family': 'BillabongRegular' })
        $('.login-display-name').text(Meteor.user()?.profile.name).css({
            'font-size': 20,
            'color': '#FFFFFF' })

Template.navbar.events {

    'click .brand, click .userpic': (evt) ->
        evt.preventDefault()
        cid = Session.get 'current_content'
        share.Router.setMain 'matrix'
        setTimeout(
            () ->
                $(window).scrollTo('#' + "#{cid}", 300, { offset: { top: -278, left: 0 } })
            , 500
        )

    'click .like-button': (evt) ->
        if !Session.get 'liked'
            Session.set 'liked', 'liked'
            cid = Session.get 'current_content'
            content = share.Content.findOne(cid)
            share.Content.update cid, { $inc: { mdfLikes: 1 } }
            Meteor.call 'track', 'like', {
                id: content.id
                image_url: content.thumbnail_resources[4].src
            }
}
