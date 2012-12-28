module.exports =
  main:
    foo: 'main-foo'
    bar: 'main-bar'
    derp: 'main-derp'
    subsection:
      foo: 'main-subsection-foo'
      bar: 'main-subsection-bar'
      derp: 'main-subsection-derp'
      subsection2:
        flerp: 'main-subsection2-flerp'
        berp: 'main-subsection2-berp'
        baz: 'main-subsection2-baz'

  section1:
    _extends: 'main'
    foo: 'section1-foo'
    bar: 'section1-bar'
    subsection:
      foo: 'section1-subsection-foo'
      bar: 'section1-subsection-bar'
      subsection2:
        flerp: 'section1-subsection2-flerp'
        berp: 'section1-subsection2-berp'

  section2:
    _extends: 'section1'
    foo: 'section2-foo'
    subsection:
      foo: 'section2-subsection-foo'
      subsection2:
        flerp: 'section2-subsection2-flerp'