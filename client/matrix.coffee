_.extend Template.matrix,

    contents: () ->
        Content.find {}, { sort: { created_time: -1 } }

    created: () ->
        console.log 'azzuza'
        $('#matrix').imagesLoaded () ->
            $('#matrix').isotope(
                itemSelector: '.item'
                layoutMode: 'cellsByRow'
            )
