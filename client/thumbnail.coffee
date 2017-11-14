Template.thumbnail.helpers {

    thumbnailUrl: () ->
        @thumbnail_resources[4].src
}

Template.thumbnail.events {

    'click .thumb': (evt) ->
        evt.preventDefault()
        Meteor.call 'track', 'photo_expand', {
            id: @id
            image_url: @thumbnail_resources[4].src
        }
        share.Router.setMain "photo/#{@_id}"
}