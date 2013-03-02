_.extend Template.navbar,

    userpic: () ->
        YLebedeva.findOne({})?.profile_picture

    rendered: () ->
        $('.text-besides-image').text('Sign In').css({ 'font-size': 36, 'font-family': 'BillabongRegular'})
        $('#login-buttons').css({ 'padding-top': '27px' })
        $('.login-button').css({ 'border': 'none' })
        $('#login-buttons-logout').css({ 'font-size': 36, 'font-family': 'BillabongRegular'})
        $('.login-display-name').text(Meteor.user()?.profile.name).css({ 'font-size': 20, 'color': '#FFFFFF' })
