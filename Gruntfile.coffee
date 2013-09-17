'use strict'

module.exports = (grunt) ->

  # Config
  # ------
  config = {}
  config.pkg = grunt.file.readJSON "package.json"
  
  grunt.loadNpmTasks "grunt-contrib-clean"
  config.clean =
    dist: [ "build" ]

  grunt.loadNpmTasks "grunt-contrib-copy"
  config.copy =
    options:
      excludeEmpty: true
    app:
      files: [
        { cwd: "app/assets/", dest: "build/", src: "**", expand: yes }
        { cwd: "vendor/scripts/", dest: "build/js/source/vendor", src: "**", expand: yes }
      ]
    test:
      files: [
        { cwd: "test/assets/", dest: "build/test/", src: "**", expand: yes }
        { cwd: "test/vendor/scripts/", dest: "build/test/js/vendor", src: "**", expand: yes }
        { cwd: "test/vendor/styles/", dest: "build/test/css", src: "**", expand: yes }
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
          dest: "build/js/source/views/templates/"
          src: "**/*.hbs"
          expand: yes
          ext: ".js"
        }
      ]

  grunt.loadNpmTasks "grunt-contrib-less"
  config.less =
    compile:
      files:
        'build/css/main.css': 'app/views/styles/main.less'
      options:
        yuicompress: false
        compress: false
        dumpLineNumbers: true
        paths: [
          'src/vendor/styles'
          'app/views/styles'
        ]

  grunt.loadNpmTasks "grunt-mocha-phantomjs"
  config.mocha_phantomjs =
    all: ["build/test/index.html"]

  grunt.loadNpmTasks "grunt-contrib-coffee"
  config.coffee =
    app:
      expand: yes
      cwd: "app/"
      src: "**/**.coffee"
      ext: ".js"
      dest: "build/js/source"
    test:
      expand: yes
      cwd: "test/"
      src: "**/**.coffee"
      ext: ".js"
      dest: "build/test/js"

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
    "copy"
    "handlebars"
    "less"
    "coffee"
  ]
  grunt.registerTask "test", [
    "build"
    "mocha_phantomjs"
  ]
  grunt.registerTask "default", "build"