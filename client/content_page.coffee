CONTENT_PAGE_TIMEOUT_DELAY = 1000 * 30

Template.content_page.helpers {

    content: () ->
        _id = Session.get 'current_content'
        share.Content.findOne _id

    moreLikes: () ->
        if @likes and @likes.count and @likes.data
            more = @likes.count - @likes.data.length
            if more > 0
                if more is 1
                    word = 'user'
                else
                    word = 'users'
                return "+ <strong class='count'>#{more}</strong> more #{word}"
        return ''
}

Template.content_page.onRendered () ->

    id = setTimeout(
        () ->
            share.Router.setMain 'matrix'
            Session.set 'timer_id', null
        , CONTENT_PAGE_TIMEOUT_DELAY
    )
    old_id = Session.get 'timer_id'

    if old_id
        clearInterval old_id

    Session.set 'timer_id', id

    prev = Session.get 'prev_content'
    curr = Session.get 'current_content'

    if prev isnt curr
        Session.set 'liked', ''
        Session.set 'prev_content', curr


Template.content_page.events {

    'click .fullpic': (evt) ->
        evt.preventDefault()
        cid = Session.get 'current_content'
        share.Router.setMain 'matrix'
        setTimeout(
            () ->
                $(window).scrollTo('#' + "#{cid}", 300, { offset: { top: -278, left: 0 } })
            , 500
        )
}

Template.comment.helpers {

    cr_time: () ->
        Date.create(parseFloat(@created_time) * 1000, { fromUTC: true }).relative()
}
