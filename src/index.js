'use strict'

require('ace-css/css/ace.css');

require('./index.html');

var Elm = require('./MainApp.elm');

var mountNode = document.getElementById('main');

var app = Elm.Main.embed(document.body);
