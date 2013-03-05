_.extend Template.thumbnail,

    thumbnailUrl: () ->
        @images.low_resolution.url

Template.thumbnail.events

    'click .thumb': (evt) ->
        evt.preventDefault()
        Meteor.call 'track', 'photo_expand',
            id: @id
            image_url: @images.low_resolution.url
        Router.setMain "photo/#{@_id}"
