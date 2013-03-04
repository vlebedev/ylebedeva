_.extend Template.thumbnail,

    thumbnailUrl: () ->
        @images.low_resolution.url

Template.thumbnail.events

    'click img': (evt) ->
        # evt.preventDefault()
        Session.set 'prev_content', null
        Session.set 'current_content', @_id
