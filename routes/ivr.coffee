module.exports = (app) ->
  tzFilter = require 'tz-filter'
  conf =
    ivr: require '../conf/ivr.coffee'
    groups: require '../conf/groups.coffee'
    people: require '../conf/people.coffee'
    times: require '../conf/times.coffee'

  app.post "/dialExt", (req, res) ->
    digits = parseInt req.body.Digits
    dial = (person, attr) ->
      res.render "dial", members: [attr], voicemail: person, confirmText: "Direct call."
    dial person, attr for person, attr of conf.people when attr.ext == digits

  app.post "/ivr", (req,res) ->
    digits = parseInt req.body.Digits
    switch digits
      when 1, 2 then render req, res, conf.ivr.routes.sales
      when 3 then render req, res, conf.ivr.routes.support
      when 4 then render req, res, conf.ivr.routes.accounts
      when 7 then render req, res, conf.ivr.routes.extension
      when 9 then render req, res, conf.ivr.routes.conferenceRooms
      else res.render req, res, conf.ivr.routes.default

  app.post "/groups/:group", (req,res) ->
    group = conf.groups[req.params.group]
    members = []
    for member in group.members
      members.push conf.people[member]
    members = tzFilter members, conf.times[group.time] unless req.query.unfiltered?
    res.render "dial", members: members, confirmText: group.text

  checkDirectDial = (body, cb) ->
    for person, attr of conf.people
      continue unless attr.direct?
      for number in attr.direct
        return cb null, person if attr.direct == body.To

  render = (req, res, target) ->
    res.render target.template, target.options
