module.exports = (app) ->

  request = require 'request'
  conf =
    conferenceRooms: require '../conf/conferenceRooms.coffee'
    general: require '../conf/general.coffee'

  app.post "/conferenceRooms", (req,res) ->
    roomID = req.body.Digits
    if !conf.conferenceRooms[roomID]?
      return res.render "digits", path: "/conferenceRooms", script: "Sorry, that room does not seem to exist. Please enter your conference room number", numDigits: 1
    res.render "digits", path: "/enterConference/#{roomID}", numDigits: 4, script: "Please enter your pin number."

  app.post "/enterConference/:id", (req,res) ->
    pin = req.body.Digits
    id = req.params.id
    room = conf.conferenceRooms[id]
    return res.send 500 if !room?
    if pin != room.admin && pin != room.user
      return res.render "digits", path: "/enterConference/#{id}", numDigits: 4, script: "Sorry, that pin number is incorrect. Please enter your pin number."
    admin = false
    admin = true if pin == room.admin
    request.get "#{conf.general.plivo.apiURL}/Conference/#{id}/", (e, r, body) ->
      body = JSON.parse body
      if r.statusCode == 404
        members = 0
      else
        members = parseInt body.conference_member_count
      res.render "conference", id: id, admin: admin, members: members
