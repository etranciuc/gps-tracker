'use strict'

module.exports = (grunt) ->

  targetDir = 'build'

  # Config
  # ------
  config = {}
  config.pkg = grunt.file.readJSON "package.json"
  
  grunt.loadNpmTasks "grunt-contrib-clean"
  config.clean =
    dist: [ targetDir ]

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