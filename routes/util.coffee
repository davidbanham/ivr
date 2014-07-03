ivr_conf = require '../conf/ivr.coffee'
module.exports = (app) ->

  app.post "/fallback", (req, res) ->
    res.send 200

  app.post "/hangup", (req, res) ->
    res.send 200

  app.post "/message", (req, res) ->
    res.send 200

  app.post "/answer", (req, res) ->
    #checkDirectDial req.body, (err, person) ->
    #  return res.send 500 if err?
    #  if person?
    #    return res.render "dial", members: [person], voicemail: person, confirmText: "Direct call."
    res.render "digits", path: "/ivr/", script: ivr_conf.routes.default.params.script, numDigits: 1

  app.post "/speakText", (req,res) ->
    res.render "speakText", text: req.query.text

  app.post "/play", (req,res) ->
    res.render "play", url: req.query.url

