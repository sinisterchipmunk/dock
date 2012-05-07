global.Dock = {Dock} = require 'dock'
global.doc = (code) -> Dock.generate 't.coffee', code, 'coffee'
