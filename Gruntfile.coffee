'use strict'

module.exports = (grunt) ->

  targetDir = 'www'

  # Config
  # ------
  config = {}
  config.pkg = grunt.file.readJSON "package.json"
  
  grunt.loadNpmTasks "grunt-contrib-clean"
  config.clean =
    dist: [ targetDir ]
    ios: [ "platform/ios/www"]
    android: [ "platform/android/assets/www"]

  grunt.loadNpmTasks "grunt-contrib-copy"
  config.copy =
    options:
      excludeEmpty: true
    app:
      files: [
        { cwd: "app/assets/", dest: targetDir, src: "**", expand: yes }
        { cwd: "vendor/scripts/", dest: "#{targetDir}/js/source/vendor", src: "**", expand: yes }
      ]
    test:
      files: [
        { cwd: "test/assets/", dest: "#{targetDir}/test/", src: "**", expand: yes }
        { cwd: "test/vendor/scripts/", dest: "#{targetDir}/test/js/vendor", src: "**", expand: yes }
        { cwd: "test/vendor/styles/", dest: "#{targetDir}/test/css", src: "**", expand: yes }
      ]

    res:
      files: [
        # ios icons
        {src: "res/icon/ios/icon-57.png", dest: "platforms/ios/GPSTracker/Resources/icons/icon.png"}
        {src: "res/icon/ios/icon-57-2x.png", dest: "platforms/ios/GPSTracker/Resources/icons/icon@2x.png"}
        {src: "res/icon/ios/icon-72.png", dest: "platforms/ios/GPSTracker/Resources/icons/icon-72.png"}
        {src: "res/icon/ios/icon-72-2x.png", dest: "platforms/ios/GPSTracker/Resources/icons/icon-72@2x.png"}
        {src: "res/icon/ios/icon-120.png", dest: "platforms/ios/GPSTracker/Resources/icons/icon-60@2x.png"}
        # ios splash screens
        {src: "res/splash/ios/screen-iphone-portrait.png", dest: "platforms/ios/GPSTracker/Resources/splash/Default~iphone.png"}
        {src: "res/splash/ios/screen-iphone-portrait-2x.png", dest: "platforms/ios/GPSTracker/Resources/splash/Default@2x~iphone.png"}
        {src: "res/splash/ios/screen-iphone-portrait-568h-2x.png", dest: "platforms/ios/GPSTracker/Resources/splash/Default-568h@2x~iphone.png"}
        # android icons
        {src: "res/icon/android/icon-96-xhdpi.png", dest: "platforms/android/res/drawable/icon.png"}
        {src: "res/icon/android/icon-72-hdpi.png",  dest: "platforms/android/res/drawable-hdpi/icon.png"}
        {src: "res/icon/android/icon-48-mdpi.png", dest: "platforms/android/res/drawable-mdpi/icon.png"}
        {src: "res/icon/android/icon-36-ldpi.png",  dest: "platforms/android/res/drawable-ldpi/icon.png"}
        {src: "res/icon/android/icon-96-xhdpi.png", dest: "platforms/android/res/drawable-xhdpi/icon.png"}
      ]

    ios:
      files: [
        { cwd: targetDir, dest: "platforms/ios/www/", src: "**", expand: yes }
      ]
    android:
      files: [
        { cwd: targetDir, dest: "platforms/android/assets/", src: "**", expand: yes }
      ]

  grunt.loadNpmTasks "grunt-contrib-handlebars"
  config.handlebars = 
    compile:
      options:
        namespace: false
        amd: yes
      files: [
        {
          cwd: "app/views/templates/"
          dest: "#{targetDir}/js/source/views/templates/"
          src: "**/*.hbs"
          expand: yes
          ext: ".js"
        }
      ]

  grunt.loadNpmTasks "grunt-contrib-less"
  config.less =
    compile:
      files: {} # defined later
      options:
        yuicompress: false
        compress: false
        dumpLineNumbers: true
        paths: [
          "src/vendor/styles"
          "app/views/styles"
        ]
  config.less.compile.files["#{targetDir}/css/main.css"] = "app/views/styles/main.less"

  grunt.loadNpmTasks "grunt-mocha-phantomjs"
  config.mocha_phantomjs =
    all: ["#{targetDir}/test/index.html"]

  grunt.loadNpmTasks "grunt-contrib-coffee"
  config.coffee =
    app:
      expand: yes
      cwd: "app/"
      src: "**/**.coffee"
      ext: ".js"
      dest: "#{targetDir}/js/source"
    test:
      expand: yes
      cwd: "test/"
      src: "**/**.coffee"
      ext: ".js"
      dest: "#{targetDir}/test/js"

  grunt.loadNpmTasks "grunt-contrib-watch"
  config.watch =
    all:
      files: [
        "app/assets/**"
        "**/**.hbs"
        "**/**.coffee"
        "**/**.less"
        "src/vendor/scripts/**"
        "test/vendor/**"
        "test/assets/**"
      ]
      tasks: [
        "copy"
        "handlebars"
        "coffee"
        "less"
      ]

  grunt.initConfig config

  # Tasks
  # -----
  grunt.registerTask "build", [
    "clean"
    "copy:app"
    "copy:test"
    "handlebars"
    "less"
    "coffee"
    "copy:ios"
    "copy:android"
    "copy:res"
  ]
  grunt.registerTask "test", [
    "build"
    "mocha_phantomjs"
  ]
  grunt.registerTask "default", "build"