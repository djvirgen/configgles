Configgles
==========

A simple config loader with support for inheritance. Supports YAML, Coffee, and
plain old JavaScript config files.

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
    var Config = require('configgles');

    // Load config file
    var config = new Config(__dirname + '/config/base.yaml');

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
      _inherits: production
      facebook:
        debug: true
        return_to: 'http://staging.mysite.com/fb'

    development:
      _inherits: staging
      facebook:
        return_to: 'http://localhost:3000/fb'

Here's how we'd load it:
    
    // Load library
    var Config = require('configgles');

    // Load config file
    var config = new Config(__dirname + '/config/base.yaml', APP.env);

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

    // In staging:
    assert(config.facebook.api_key == 123); // inherited from production!
    assert(config.facebook.secret == 'abc'); // also inherited from production!!
    assert(config.facebook.debug == true); // inherited from staging!
    assert(config.facebook.return_to == 'http://staging.mysite.com/fb');