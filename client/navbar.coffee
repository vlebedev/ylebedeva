_.extend Template.navbar,

    rendered: () ->
        $('.text-besides-image').text('Sign In').css({ 'font-size': 36, 'font-family': 'BillabongRegular'})
        $('#login-buttons').css({ 'padding': '18px' })
        $('.login-button').css({ 'border': 'none' })
