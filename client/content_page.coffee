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

_.extend Template.comment,

    created_time: () ->
        Date.utc.create(parseFloat(@created_time)*1000).relative()

Template.content_page.events

    'click img': (evt) ->
        # evt.preventDefault()
        Session.set 'current_content', null