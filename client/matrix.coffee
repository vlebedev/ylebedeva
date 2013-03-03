_.extend Template.matrix,

    contents: () ->
        Content.find {}, { sort: { created_time: -1 } }

    current_content: () ->
        Session.get 'current_content'

    created: () ->
        $('#matrix').imagesLoaded () ->
            $('#matrix').isotope(
                itemSelector: '.item'
                layoutMode: 'fitRows'
            )
