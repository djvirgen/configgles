require 'js-yaml'

class Config
  constructor: (@_path, @_section) ->
    data = require @_path
    if @_section?
      this.loadSection data
    else
      this.loadAll data

  loadSection: (data) ->
    section = @_section
    sections = []

    # Gather all sections including ancestors in reverse order (eldest first)
    while section && data[section]?
      sections.unshift section
      section = data[section]._extends

    for section in sections
      do (section) =>
        deepMerge this, data[section]

  loadAll: (data) ->
    this[key] = value for key, value of data

deepMerge = (obj1, obj2) ->
  for key, value of obj2
    do (key, value) ->
      if obj1[key]? && typeof value == 'object'
        deepMerge obj1[key], value
      else
        obj1[key] = value

module.exports = Config