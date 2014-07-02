module.exports = (app) ->

  email = require 'mailer'
  conf =
    general: require '../conf/general.coffee'

  app.post "/recording/:dest", (req,res) ->
    email.send
      host: 'smtp.gmail.com'
      port: 465
      ssl: true
      domain: conf.general.email.domain
      to: req.params.dest
      from: conf.general.email.from
      subject: "Voicemail message recieved from #{req.body.CallerName}"
      body: "Retreive the message at: #{req.body.RecordUrl}"
      authentication: "login"
      username: conf.general.email.user
      password: conf.general.email.pass
    , (err, result) ->
      return console.log "Error in mailer", JSON.stringify(err) if err
      res.send 200
