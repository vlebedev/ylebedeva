_.extend Template.thumbnail,

    thumbnailUrl: () ->
        @images.low_resolution.url

Template.thumbnail.events

    'click .thumb': (evt) ->
        evt.preventDefault()
        Router.setMain "photo/#{@_id}"
