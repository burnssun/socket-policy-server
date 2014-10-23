policy_file = """
<?xml version='1.0'?>
<cross-domain-policy>
        <allow-access-from domain="*" to-ports="*" />
</cross-domain-policy>
"""

server = require("net").createServer (stream) ->
  stream.setEncoding "utf8"
  stream.setTimeout 3000
  stream.on "connect", ->
    console.log "Got connection from " + stream.remoteAddress + "."
    return

  stream.on "data", (data) ->
    if data is "<policy-file-request/>\u0000"
      console.log "Good request. Sending file to " + stream.remoteAddress + "."
      stream.end policy_file + "\u0000"
    else
      console.log "Bad request from " + stream.remoteAddress + "."
      stream.end()
    return

  stream.on "end", ->
    stream.end()
    return

  stream.on "timeout", ->
    console.log "Request from " + stream.remoteAddress + " timed out."
    stream.end()
    return

  stream.on "error", (err)->
    console.log "error", err.stack
    return


server.listen(843)
