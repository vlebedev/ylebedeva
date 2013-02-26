YLEBEDEVA_ID = '4695387'

Content = new Meteor.Collection 'content'

Meteor.publish 'content', () ->

    accessToken = Meteor.user()?.services?.instagram?.accessToken
    result = Meteor.http.get "https://api.instagram.com/v1/users/#{YLEBEDEVA_ID}/media/recent/?access_token=#{accessToken}"
    console.log result.data?.data

    Content.find {}


Meteor.startup ->
    console.log "APP_START:: Application initialization started..."
    console.log "APP_START:: Application initialization finished..."
