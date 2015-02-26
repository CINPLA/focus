from flask import Flask
app = Flask(__name__)
from flask import request
from flask import Response

import json
import dbus

@app.route('/receive', methods=['POST'])
def slack_receive():
#========================================================================
# return w3w link
##===========================================================================

    print "received"
    msg = request.form['text']
    print msg
    #get the interface

    #get the session bus
    bus = dbus.SessionBus()
    name = "org.cinpla.focus"
    the_object = bus.get_object(name, "/")
    the_interface = dbus.Interface(the_object, "local.focus.Pong")
    reply = the_interface.ping(msg)
    print(reply)


    return Response(json.dumps({'text': reply}))

@app.route('/')
def root():
    return ''

import os
if __name__ == '__main__':
    port = int(os.environ.get("PORT", 27020))
    app.run(host='0.0.0.0', port=port)
