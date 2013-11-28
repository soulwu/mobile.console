'use strict'

do (window, document) ->
  inited = false
  logContainer = null

  init = ->
    consoleWin = document.createElement 'div'
    consoleWin.innerHTML = '''
      <div class="console-log-container" style="width: 90%; color: #ffffff; font-size: 12px; text-align: left; margin: 0 auto"></div>
      <div class="console-input"></div>
      <div class="console-control"></div>
    '''
    consoleWin.className = 'console-win'
    consoleWin.style.position = 'fixed'
    consoleWin.style.bottom = 0
    consoleWin.style.left = 0
    consoleWin.style.width = '100%'
    consoleWin.style.height = '150px'
    consoleWin.style.background = 'black'
    consoleWin.style.opacity = '0.5'
    consoleWin.style.zIndex = 999999
    consoleWin.style.display = 'block'

    document.body.appendChild consoleWin
    logContainer = document.querySelector '.console-log-container'
    consoleWin.style.display = 'none' if not logContainer
    if logContainer
      for info in logStack
        p = document.createElement 'p'
        p.innerText = info
        logContainer.appendChild p
    inited = true

  document.addEventListener('DOMContentLoaded', init, false);

  logStack = []

  methods = {}

  for name, fn of window.console when typeof fn is 'function'
    methods[name] = do (fn) ->
      ->
        fn.apply window.console, arguments

  log = (msg) ->
    methods.log msg
    return logStack.push msg.toString() if not inited
    return if not logContainer?
    p = document.createElement 'p'
    p.innerText = msg.toString()
    logContainer.appendChild p
    return

  window.console.log = log

