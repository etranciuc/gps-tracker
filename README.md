# GPS Tracker

<img src="https://raw.github.com/foobugs/gps-tracker/master/screenshot.png" border="0" align="right" width="320" height="444" />

This project uses the [geolocation API](dev.w3.org/geo/api/spec-source.html) (if provided by the web-client) to show a map and information about the client’s real location.

It also is an experiment to see which clients (mobile devices) provide which informations and update intervals when using `watchPosition`.

This project was build using [brunch](http://brunch.io/) as a boilerplate for a [backbone](backbonejs.org)/[chaplin](http://chaplinjs.org/) application. It’s hosted on heroku which provides a nice environment for such litte projects.

# Demo

[http://gps-tracker.herokuapp.com](http://gps-tracker.herokuapp.com)

# Build & Run

## Requirements

* NPM
* Node

## Installing

* Download or clone repository and install dependencies using `npm install`.
* Create first Build with `grunt build`
* Open `index.html`

## Static WebServer

	coffee server.coffee

## Contact

If you have questions or anything else …

* Twitter: [@foobugs](https://twitter.com/foobugs)
* E-Mail: [mail@foobugs.com](mail:mail@foobugs.com?subject=gps-tracker)
