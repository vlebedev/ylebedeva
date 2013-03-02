_.extend Template.matrix,

    contents: () ->
        Content.find {}, { sort: { created_time: -1 } }
