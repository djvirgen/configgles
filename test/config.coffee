require 'should'

describe 'Config', ->
  Config = require '../lib'

  paths =
    simple:
      yaml: __dirname + '/configs/simple.yaml'
      coffee: __dirname + '/configs/simple.coffee'
      js: __dirname + '/configs/simple.js'
    nested:
      yaml: __dirname + '/configs/nested.yaml'
      coffee: __dirname + '/configs/nested.coffee'
      js: __dirname + '/configs/nested.js'
    inheritance:
      yaml: __dirname + '/configs/inheritance.yaml'
      coffee: __dirname + '/configs/inheritance.coffee'
      js: __dirname + '/configs/inheritance.js'
    complex:
      yaml: __dirname + '/configs/complex.yaml'
      coffee: __dirname + '/configs/complex.coffee'
      js: __dirname + '/configs/complex.js'

  for type, path of paths.simple
    do (type, path) ->
      describe "with simple #{type} config", ->
        beforeEach ->
          this.config = new Config(path)

        for key, value of {foo: "value-foo", bar: "value-bar", derp: "value-derp"}
          do (key, value) ->
            it "should have property #{key} with value of #{value}", ->
              this.config.should.have.property(key, value)

        for key in ['nonexistent1', 'nonexistent2', 'nonexistent3']
          do (key) ->
            it "should not have property #{key}", ->
              this.config.should.not.have.property(key)

  for type, path of paths.nested
    do (type, path) ->
      describe "with nested #{type} config", ->
        beforeEach ->
          this.config = new Config(path)

        it "should have nested property third with value of value-third", ->
          this.config.first.second.should.have.property('third', 'value-third')

  for type, path of paths.inheritance
    do (type, path) ->
      describe "with inheritance #{type} config", ->
        describe 'section with no ancestors', ->
          beforeEach ->
            this.config = new Config(path, 'main')

          for key, value of {foo: 'main-foo', bar: 'main-bar', derp: 'main-derp'}
            do (key, value) ->
              it "should have property #{key} with value of #{value}", ->
                this.config.should.have.property(key, value)

        describe 'section with single ancestor', ->
          beforeEach ->
            this.config = new Config(path, 'section1')

          for key, value of {foo: 'section1-foo', bar: 'section1-bar', derp: 'main-derp'}
            do (key, value) ->
              it "should have property #{key} with value of #{value}", ->
                this.config.should.have.property(key, value)

        describe 'section with multiple ancestors', ->
          beforeEach ->
            this.config = new Config(path, 'section2')

          for key, value of {foo: 'section2-foo', bar: 'section1-bar', derp: 'main-derp'}
            do (key, value) ->
              it "should have property #{key} with value of #{value}", ->
                this.config.should.have.property(key, value)

  for type, path of paths.complex
    do (type, path) ->
      describe "with complex #{type} config", ->
        describe 'section with no ancestors', ->
          beforeEach ->
            this.config = new Config(path, 'main')

          for key, value of {foo: 'main-subsection-foo', bar: 'main-subsection-bar', derp: 'main-subsection-derp'}
            do (key, value) ->
              it "should have nested property #{key} with value of #{value}", ->
                this.config.subsection.should.have.property(key, value)

          for key, value of {flerp: 'main-subsection2-flerp', berp: 'main-subsection2-berp', baz: 'main-subsection2-baz'}
            do (key, value) ->
              it "should have nested property #{key} with value of #{value}", ->
                this.config.subsection.subsection2.should.have.property(key, value)

        describe 'section with single ancestor', ->
          beforeEach ->
            this.config = new Config(path, 'section1')

          for key, value of {foo: 'section1-subsection-foo', bar: 'section1-subsection-bar', derp: 'main-subsection-derp'}
            do (key, value) ->
              it "should have nested property #{key} with value of #{value}", ->
                this.config.subsection.should.have.property(key, value)

          for key, value of {flerp: 'section1-subsection2-flerp', berp: 'section1-subsection2-berp', baz: 'main-subsection2-baz'}
            do (key, value) ->
              it "should have nested property #{key} with value of #{value}", ->
                this.config.subsection.subsection2.should.have.property(key, value)

        describe 'section with multiple ancestors', ->
          beforeEach ->
            this.config = new Config(path, 'section2')

          for key, value of {foo: 'section2-subsection-foo', bar: 'section1-subsection-bar', derp: 'main-subsection-derp'}
            do (key, value) ->
              it "should have nested property #{key} with value of #{value}", ->
                this.config.subsection.should.have.property(key, value)

          for key, value of {flerp: 'section2-subsection2-flerp', berp: 'section1-subsection2-berp', baz: 'main-subsection2-baz'}
            do (key, value) ->
              it "should have nested property #{key} with value of #{value}", ->
                this.config.subsection.subsection2.should.have.property(key, value)

  describe 'arrays', ->
    it 'should replace array value by default', ->
      config = new Config("#{__dirname}/configs/arrays", 'bar')
      config.list.should.have.lengthOf 2
      config.list[0].should.eql "four"
      config.list[1].should.eql "five"
