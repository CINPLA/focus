#!/usr/bin/env python
# -*- coding: utf-8 -*-

from flask import Flask
app = Flask(__name__)
import flask
from flask import render_template
from flask import request
from flask import Response
from flask import abort

import json

#from settings import slack_key
import re

@app.route('/receive', methods=['POST'])
def slack_receive():
#========================================================================
# return w3w link
##===========================================================================

    print "received"
    msg = request.form['text']
    print msg

    import dbus

    #get the session bus
    bus = dbus.SessionBus()
    #get the object
    name = "org.example.QtDBus.PingExample"
    the_object = bus.get_object(name, "/")
    #get the interface
    the_interface = dbus.Interface(the_object, "local.focus.Pong")

    #call the methods and print the results
    reply = the_interface.ping("ape")
    print(reply)


    return Response(json.dumps({'text': "banana"}))

@app.route('/')
def root():
    return ''

import os
if __name__ == '__main__':
    port = int(os.environ.get("PORT", 27020))
    app.run(host='0.0.0.0', port=port)
