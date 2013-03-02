_.extend Template.thumbnail,

    thumbnailUrl: () ->
        @images.thumbnail.url

Template.thumbnail.events

    'click img': (evt) ->
        # evt.preventDefault()
        Session.set 'current_content', @_id