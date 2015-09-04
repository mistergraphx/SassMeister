module.exports =
  storageDefaults:
    app:
      sass: ''
      css: ''
      html: ''
      outputStyle: 'expanded'
      compiler: '3.4'
      syntax: 'scss'
      originalSyntax: 'scss'
      dependencies: {}

    preferences:
      theme: 'tomorrow'
      emmet: false
      vim: false
      scrollPastEnd: false

  _themes: [
    'dawn'
    'github'
    'kuroir'
    'solarized_light'
    'tomorrow'
    'merbivore_soft'
    'monokai'
    'solarized_dark'
    'tomorrow_night_eighties'
  ]

  themes: ->
    themes = {}
    for theme in @_themes
      themes[theme] = theme.replace('_', ' ').split(' ').map( (i) ->
        i[0].toUpperCase() + i.substring(1)
      ).join ' '
    themes

  outputStyles: [
    'expanded'
    'nested'
    'compact'
    'compressed'
  ]