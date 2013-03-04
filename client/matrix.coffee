LIMIT_DELTA = 15

_.extend Template.matrix,

    contents: () ->
        Content.find {}, { sort: { created_time: -1 } }

    current_content: () ->
        Session.get 'current_content'

    loading: () ->
        Session.get 'loading'

    created: () ->
        $('#matrix').isotope(
            itemSelector: '.item'
            layoutMode: 'fitRows'
        )

        $(window).scroll () ->
            if !Session.get('loading') and $(window).scrollTop() is $(document).height() - $(window).height()
                Session.set 'loading', yes
                newLimit = Session.get('content_limit') + LIMIT_DELTA
                Session.set 'content_limit', newLimit
                console.log "newLimit: #{newLimit}"
