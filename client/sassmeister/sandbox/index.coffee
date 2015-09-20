'use strict'

config = require '../config'

require 'angular'
require 'angular-resource'
require 'angular-load'

angular.module 'SassMeister.sandbox', [
  'ngResource'
  'angularLoad'
]

.factory 'sandboxServer', ($resource) ->
    $resource config.sandbox, {}

.factory 'Sandbox', [
  'sandboxServer'
  'angularLoad'
  (sandboxServer, angularLoad) ->

    updateIframe = (css, html, reset) ->
      if reset?
        newContent = reset: true

      else
        newContent =
          css: css
          html: html

      document.getElementById('rendered-html')
        .contentWindow
        .postMessage(JSON.stringify(newContent), '*')

    html: (app) ->
      updateIframe app.css, app.html

    haml: (app) ->
      sandboxServer.save {
        input: app.html
        syntax: 'haml'
      }
      .$promise.then (data) ->
        app.renderedHTML = data.html
        updateIframe app.css, data.html

    markdown: (app) ->
      sandboxServer.save {
        input: app.html
        syntax: 'markdown'
      }
      .$promise.then (data) ->
        app.renderedHTML = data.html
        updateIframe app.css, data.html

    textile: (app) ->
      sandboxServer.save {
        input: app.html
        syntax: 'textile'
      }
      .$promise.then (data) ->
        app.renderedHTML = data.html
        updateIframe app.css, data.html

    jade: (app) ->
      renderJade = ->
        html = window.jade.render(app.html, {pretty: true})
        app.renderedHTML = html
        updateIframe app.css, html

      unless window.jade
        angularLoad.loadScript 'https://cdn.rawgit.com/jadejs/jade/1.11.0/jade.js'
          .then ->
            do renderJade

      else
        do renderJade

    render: (app) ->
      @[app.htmlSyntax] app

    update: updateIframe

    reset: ->
      updateIframe null, null, true

    onReady: (app) ->
      # When the sandbox iFrame loads it will post a message back to the parent (the main app frame.)
      # $scope.on('viewContentLoaded') fires when the _parent_ view has loaded, but _before_ the iFrame is ready and setTimeout is dumb.
      # So, we'll let the iFrame _tell_ us when it's ready.
      window.onmessage = (event) =>
        if event.origin == config.sandbox
          if app.renderedHTML
            @update app.css, app.renderedHTML
          else
            @render app
]

