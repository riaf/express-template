###
global module:false
###

spawn = require("child_process").spawn

module.exports = (grunt)->

  # Project configuration.
  grunt.initConfig

    # Metadata.
    pkg: grunt.file.readJSON "package.json"
    banner: '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
      '<%= grunt.template.today("yyyy-mm-dd") %>\n' +
      '<%= pkg.homepage ? "* " + pkg.homepage + "\\n" : "" %>' +
      '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %>;' +
      ' Licensed <%= _.pluck(pkg.licenses, "type").join(", ") %> */\n'

    # Task configuration.
    uglify:
      options:
        banner: "<%= banner %>"
      dist:
        files:
          "public/javascripts/app.min.js": ["resources/javascripts/app.js"]
    less:
      options:
        paths: ["components/bootstrap/less"]
        yuicompress: true
      dist:
        files:
          "public/stylesheets/style.min.css": ["resources/less/style.less"]
    qunit:
      files: ["test/**/*.html"]
    watch:
      js:
        files: "resources/javascripts/**/*.js"
        tasks: ["qunit", "uglify"]
        options:
          interrupt: true
      less:
        files: "resources/stylesheets/**/*.less"
        tasks: ["less"]
        options:
          interrupt: true
    coffee:
      server:
        dist: "./app/"
        src:  "./src/"
      client:
        dist: "./resources/javascripts/"
        src:  "./resources/coffeescripts/"


  # These plugins provide necessary tasks.
  grunt.loadNpmTasks "grunt-contrib-uglify"
  grunt.loadNpmTasks "grunt-contrib-less"
  grunt.loadNpmTasks "grunt-contrib-qunit"
  grunt.loadNpmTasks "grunt-contrib-watch"

  # Default task.
  grunt.registerTask "default", ["qunit", "coffee", "uglify", "less"]

  # Coffee task
  grunt.registerMultiTask 'coffee', 'Convert Coffee Script to JavaScript', ->
    grunt.log.writeln "coffee: compling #{ @target }..."

    compile = spawn "coffee", ["-wbco", @data.dist, @data.src]

    compile.stdout.on "data", (buffer) ->
      if buffer
        grunt.log.writeln buffer.toString().trim()

    compile.stderr.on "data", (buffer) ->
      if buffer
        grunt.log.writeln buffer.toString().trim()

