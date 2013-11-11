require 'require-yaml'

class Config
  constructor: (@_path, @_section) ->
    # deep clone data to prevent reference errors
    data = clone require @_path

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
    @loadEnvVars()

  loadEnvVars: ->
    overrideWithEnvVars = (prefix, data) ->
      for key, value of data
        do (data) ->
          deepKey = if prefix.length then "#{prefix}.#{key}" else key
          return overrideWithEnvVars deepKey, value if typeof value == 'object'
          data[key] = process.env[deepKey] if process.env[deepKey]?

    overrideWithEnvVars '', @

deepMerge = (obj1, obj2) ->
  for key, value of obj2
    do (key, value) ->
      if value._merge && Array.isArray(value._merge) && Array.isArray(obj1[key])
        # Merge arrays
        obj1[key] = obj1[key].concat value._merge
      else if Array.isArray(obj1[key]) && Array.isArray(value)
        # Replace array
        obj1[key] = value
      else if obj1[key]? && typeof value == 'object'
        # deep merge objects
        deepMerge obj1[key], value
      else
        obj1[key] = value

clone = (obj) ->
  return obj if obj == null || typeof obj != 'object'

  temp = obj.constructor() # changed

  for key, value of obj
    do (key, value) ->
      temp[key] = clone obj[key]

  temp

module.exports = Config
