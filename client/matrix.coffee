LIMIT_DELTA = 30

Template.matrix.helpers {

    contents: () ->
        share.Content.find {}, { sort: { created_time: -1 } }

    current_content: () ->
        Session.get 'current_content'

    loading: () ->
        Session.get 'loading'
}

Template.matrix.onCreated () ->

        $('#matrix').imagesLoaded () ->
            $('#matrix').isotope({
                itemSelector: '.item'
                layoutMode: 'fitRows'
            })

Template.matrix.onRendered () ->

        $(window).scroll () ->
            height = if window.innerHeight then window.innerHeight else $(window).height()
            if !Session.get('loading') and !Session.get('current_content') and $(window).scrollTop() is $(document).height() - height
                Session.set 'loading', yes
                newLimit = Session.get('content_limit') + LIMIT_DELTA
                Session.set 'content_limit', newLimit
                ## console.log "newLimit: #{newLimit}"
