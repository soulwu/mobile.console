module.exports = (grunt) ->
  pkg = require './package.json'

  modules = [
    'temp/console.js'
  ]

  grunt.initConfig
    pkg: pkg

    # Clean
    # -----
    clean:
      build: 'build'
      temp: 'temp'
      components: 'components'


    # CoffeeScript Compilation
    # ------------------------
    coffee:
      compile:
        files: [
          expand: true
          dest: 'temp/'
          cwd: 'src'
          src: '**/*.coffee'
          ext: '.js'
        ]

      options:
        bare: true

    # Concatenation
    # -------------
    concat:
      universal:
        files: [
          dest: 'build/<%= pkg.name %>.js'
          src: modules
        ]

      options:
        separator: ';'
        banner: '''
        /*!
         * <%= pkg.name %> <%= pkg.version %>
         *
         * <%= pkg.description %>
         *
         * <%= pkg.name %> may be freely distributed under the MIT license.
         */

        '''

    # Minify
    # ------
    uglify:
      options:
        mangle: true
      universal:
        files:
          'build/<%= pkg.name %>.min.js': 'build/<%= pkg.name %>.js'

    # Watching for changes
    # --------------------
    watch:
      files: ['src/**/*.coffee']
      tasks: [
        'build'
      ]


  for name of pkg.devDependencies when name.substring(0, 6) is 'grunt-'
    grunt.loadNpmTasks name


  grunt.registerTask 'prepare', [
    'clean'
    'clean:components'
  ]

  grunt.registerTask 'build', [
    'coffee:compile'
    'concat:universal'
    'uglify'
  ]

  grunt.registerTask 'default', [
    'clean'
    'build'
  ]
