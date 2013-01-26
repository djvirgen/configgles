Configgles
==========

A simple config loader with support for inheritance. Supports YAML, Coffee, and
plain old JavaScript config files. Handles deep merges automatically allowing
you to override just what you need while keeping the rest.

Installation
------------

    npm install configgles

Usage
-----

In its simplest form, Configgles will parse your config file and return an
object. Here's a simple YAML config stored in `config/base.yaml`:

    foo: bar
    derpy: doo

Here's how we'd load it:

    // Load library
    var Configgles = require('configgles');

    // Load config file
    var config = new Configgles(__dirname + '/config/base.yaml');

    // Access config values!!
    assert(config.foo == 'bar');
    assert(config.derpy == 'doo');

Inheritance!!
-------------

If you need to support various configurations in different environments, you
can use inheritance to DRY up your config:

    production:
      facebook:
        api_key: 123
        secret: abc
        debug: false
        return_to: 'http://www.mysite.com/fb'

    staging:
      _extends: production
      facebook:
        debug: true
        return_to: 'http://staging.mysite.com/fb'

    development:
      _extends: staging
      facebook:
        return_to: 'http://localhost:3000/fb'

Here's how we'd load it:
    
    // Load library
    var Configgles = require('configgles');

    // Load config file
    var config = new Configgles(__dirname + '/config/base.yaml', process.env.RACK_ENV);

    // In production:
    assert(config.facebook.api_key == 123);
    assert(config.facebook.secret == 'abc');
    assert(config.facebook.debug == false);
    assert(config.facebook.return_to == 'http://www.mysite.com/fb');

    // In staging:
    assert(config.facebook.api_key == 123); // inherited from production!
    assert(config.facebook.secret == 'abc'); // also inherited from production!!
    assert(config.facebook.debug == true);
    assert(config.facebook.return_to == 'http://staging.mysite.com/fb');

    // In development:
    assert(config.facebook.api_key == 123); // inherited from production!
    assert(config.facebook.secret == 'abc'); // also inherited from production!!
    assert(config.facebook.debug == true); // inherited from staging!
    assert(config.facebook.return_to == 'http://localhost:3000/fb');

Arrays!!
--------

There are two ways to handle arrays when it comes to inheritance: replace the
parent array (default behavior), or merge with the parent. Here's how to
configure them in a yaml config file:

    production:
      contacts:
        - "foo@example.com"
        - "bar@example.com"
      navigation:
        - "home"
        - "contact"

    staging:
      _extends: production
      contacts: # this entire array will replace the array in production
        - "staging-foo@example.com"
      navigation:
        _merge: # by using _merge, you can merge this array with the parent
          - "new-page"

Using this yaml file, the resulting configs would be:

    var config = new Configgles('config.yaml', 'production');
    assert(config.contacts.length == 2); // true!
    assert(config.contacts[0] == 'foo@example.com'); // true!
    assert(config.contacts[1] == 'bar@example.com'); // true!
    assert(config.navigation.length == 2); // true!
    assert(config.navigation[0] == 'home'); // true!
    assert(config.navigation[1] == 'contact'); // true!

    var config2 = new Configgles('config.yaml', 'staging');
    assert(config.contacts.length == 1); // only 1 because the array was replaced
    assert(config.contacts[0] == 'staging-foo@example.com'); // true!
    assert(config.navigation.length == 3); // array is merged with parent!
    assert(config.navigation[0] == 'home'); // still true!
    assert(config.navigation[1] == 'contact'); // also still true!
    assert(config.navigation[2] == 'new-page'); // true!!

Development
-----------

Want to contribue to Configgles?

*Run tests*

    npm run-script test