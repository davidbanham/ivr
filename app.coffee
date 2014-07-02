###
Module dependencies.
###
express = require 'express'
request = require 'request'

conf =
  general: require './conf/general.coffee'
  people: require './conf/people.coffee'

app = module.exports = express.createServer()

#plivoAPI = "https://#{conf.general.plivo.id}:#{conf.general.plivo.token}@api.plivo.com/v1/Account/#{conf.general.plivo.id}"

# Configuration
app.configure ->
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.dynamicHelpers
    appUrl: (req, res) ->
      return url

app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

app.configure "production", ->
  app.use express.errorHandler()

url = conf.general.url


createPlivoApp = () ->
  request.get "#{conf.general.plivo.apiURL}/Application/", (e, r, body) ->
    plivoAppOpts =
      answer_url: "#{conf.general.url}/answer"
      hangup_url: "#{conf.general.url}/hangup"
      app_name: conf.general.plivo.app_name
    throw e if e?
    body = JSON.parse body
    for object in body.objects
      exists = object if object.app_name == conf.general.plivo.app_name
    if exists?
      request.post "#{conf.general.plivo.apiURL}/Application/#{exists.app_id}/", {json: plivoAppOpts}, (e, r, body) ->
        throw e if e?
        conf.general.plivo.app_id = exists.app_id
        configurePlivoApp()
    else
      request.post "#{conf.general.plivo.apiURL}/Application/", {json: plivoAppOpts}, (e, r, body) ->
        console.log "Creating plivo app"
        throw e if e?
        createPlivoApp()

configurePlivoApp = () ->
  #request.get "#{conf.general.plivo.apiURL}/Endpoint/", (e, r, body) ->
  #  throw e if e?
  #  body = JSON.parse body
  #  for endpoint in conf.plivo.endpoints
  #    for object in body.objects
  #      exists = object if object.alias == endpoint
  #    if exists?
  #      request.post "#{conf.general.plivo.apiURL}/Endpoint/#{exists.endpoint_id}/", {json: {app_id: conf.plivo.app_id}}, (e, r, body) ->
  #        throw e if e?
  #    else
  #      throw "Endpoint #{endpoint} does not exist and I won't create it for you."
  checkEndpoints = () ->
    request.get "#{conf.general.plivo.apiURL}/Endpoint/", (e, r, body) ->
      throw e if e?
      activeEndpoints = {}
      body = JSON.parse body
      for endpoint in body.objects
        activeEndpoints[endpoint.alias] = endpoint
      counter = 0
      for person of conf.people
        if !activeEndpoints[person]?
          counter++
          creating = true
          opts =
            username: person.split('@')[0]
            password: hashPass().pass
            app_id: conf.general.plivo.app_id
            alias: person
          console.log opts
          request.post "#{conf.general.plivo.apiURL}/Endpoint/", {json: opts}, (e, r, body) ->
            console.log body
            throw e if e?
            counter--
            if counter = 0
              return checkEndpoints() if creating?
        else
          person.sip = activeEndpoints[person]
      if counter = 0
        return checkEndpoints() if creating?
  #checkEndpoints()

createPlivoApp()

# Routes
app.get "/", (req,res) ->
  res.send 200

require('./routes/util.coffee')(app)
require('./routes/conference.coffee')(app)
require('./routes/ivr.coffee')(app)
require('./routes/util.coffee')(app)
require('./routes/voicemail.coffee')(app)

app.listen 3000 or process.env.PORT
console.log "Express server listening on port %d", app.address().port
