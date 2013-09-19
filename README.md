Demo:
===============================================================================

* [Web-App on Heroku](http://gps-tracker.herokuapp.com)
* [Apple App-Store](https://itunes.apple.com/us/app/super-gps-tracker/id690438689?mt=8)
* [Google Play Store](https://play.google.com/store/apps/details?id=com.foobugs.gpstracker)

Description
===============================================================================

This project uses the [geolocation API](dev.w3.org/geo/api/spec-source.html) (if provided by the web-client) to show a map and information about the client’s real location.

It also is an experiment to see which clients (mobile devices) provide which informations and update intervals when using `watchPosition`.

This project is written in [coffeescript](http://coffeescript.org/) and uses [backbone](backbonejs.org), [chaplin](http://chaplinjs.org/) as solid framework and is build with [grunt](http://gruntjs.com/).

Additionally the project is automatically tested using [CirlceCI](circleci.com).


Build
===============================================================================

	npm install

## Web-App

	grunt build
	coffee server.coffee
	// open localhost:8080

## iOS

The project includes a complete XCode5 Project which can be used to build the iOS App.

## Android

The project includes a complete Android Studio Project which can be used to build the Android App.

Contact
===============================================================================
If you have questions or any other inquiry concerning the Super GPS Tracker app use one of the following:

* Twitter: [@foobugs](https://twitter.com/foobugs)
* E-Mail: [mail@foobugs.com](mail:mail@foobugs.com?subject=gps-tracker)