### global redis, redislistener ###

# The Frontend of the API: ties everything together
# make sure to add all new features here when extending the system
express = require('express')
app = express()
# var ioredis = require('ioredis')
# var underscore = require('underscore')
morgan = require('morgan')
config = require('../config.js')
# var fs = require('fs')
ecstatic = require('ecstatic')
# var https = require('https')
app.use morgan('tiny')
console.log 'Booting Frontend'
# Connect to the redis server
config.connect 'frontend'


# CORS headers
app.use (req, res, next) ->
  res.header 'Access-Control-Allow-Origin', '*'
  res.header 'Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept'
  next()

###
var privateKey = fs.readFileSync('../sslcert/server.key').toString()
var certificate = fs.readFileSync('../sslcert/server.crt').toString()
var credentials = {key: privateKey, cert: certificate}
###

app.use '/api', require './routes/schedules'
app.use '/api', require './routes/authentication'
app.use '/', ecstatic root: config.webroot

app.listen 3000



console.log 'Reporting to service set'
redis.zincrby 'services', 1, 'frontend'
# add us to the list
process.on 'exit', (code) ->
  # for clean exit
  console.log 'Removing From service list'
  redis.zincrby 'services', -1, 'frontend'
  # remove all instances
  redis.quit()
  redislistener.quit()
  return
process.on 'SIGINT', (code) ->
  # for CTRL-C
  process.exit()
  # Do regular exit
  return

# ---
# generated by js2coffee 2.2.0