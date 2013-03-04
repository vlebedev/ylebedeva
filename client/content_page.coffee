CONTENT_PAGE_TIMEOUT_DELAY = 2000*60

_.extend Template.content_page,

    content: () ->
        _id = Session.get 'current_content'
        Content.findOne(_id)

    moreLikes: () ->
        more = @likes.count - @likes.data.length
        if more > 0
            if more is 1
                word = 'user'
            else
                word = 'users'
            return "+ <strong class='count'>#{more}</strong> more #{word}"

    rendered: () ->
        id = setTimeout(
            () ->
                Session.set 'current_content', null
                Session.set 'prev_content', null
                Session.set 'timer_id', null
            , CONTENT_PAGE_TIMEOUT_DELAY
        )

        old_id = Session.get 'timer_id'
        if old_id
            clearInterval old_id

        Session.set 'timer_id', id

Template.content_page.events

    'click img': (evt) ->
        # evt.preventDefault()
        Session.set 'current_content', null
        Session.set 'prev_content', null

_.extend Template.comment,

    created_time: () ->
        Date.utc.create(parseFloat(@created_time)*1000).relative()

