module.exports =
  main:
    foo: 'main-foo'
    bar: 'main-bar'
    derp: 'main-derp'

  section1:
    _extends: 'main'
    foo: 'section1-foo'
    bar: 'section1-bar'

  section2:
    _extends: 'section1'
    foo: 'section2-foo'