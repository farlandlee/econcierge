exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: {
        "js/admin.js": /^(web\/static\/admin\/js)/,
        "js/app.js": /^(web\/static\/js)/,
        "js/vendor.js": [
          /^(bower_components)/,
          /^(deps)/
        ]
      }
    },
    stylesheets: {
      joinTo: {
        "css/app.css": [
          /^(web\/static\/css)/,
          /^(bower_components\/font\-awesome)/,
          /^(bower_components\/motion\-ui\/src)/
        ],
        "css/admin.css": [
          /^(web\/static\/admin\/css)/,
          /^(bower_components\/bootstrap)/,
          /^(bower_components\/chosen)/,
          /^(bower_components\/font\-awesome)/
        ]
      },
      order: {
        before: /^(bower_components)/
      }
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/web/static/assets". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: /^(web\/static\/assets)/,
    ignored: [
      /[\\/]_/, //any file starting with `_`, like sass partials
      /^(bower_components\/foundation-sites\/scss)/,
      /^(bower_components\/what-input\/)/,
      /^(bower_components\/motion\-ui)/
    ]
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: [
      "deps/phoenix/web/static",
      "deps/phoenix_html/web/static",
      "web/static",
      "test/static"
    ],

    // Where to compile files to
    public: "priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/web\/static\/vendor/, /bower_components/]
    },
    afterBrunch: [
      [
        'mkdir -p priv/static/fonts',
        'cp -r bower_components/bootstrap/dist/fonts/* priv/static/fonts/',
        'cp -r bower_components/font-awesome/fonts/* priv/static/fonts/',
        'cp bower_components/chosen/*.png priv/static/css/'
      ].join(' && ')
    ],
    sass: {
      mode: 'native',
      options: {
        includePaths: [
          'bower_components/foundation-sites/scss/',
          'bower_components/spinners/stylesheets',
          'bower_components/motion-ui/src/',
        ]
      }
    },
    postcss: {
      processors: [
        require('autoprefixer')({browsers: ['last 2 versions']})
      ]
    }
  },
  modules: {
    autoRequire: {
      "js/app.js": ["web/static/js/app"],
      "js/admin.js": ["web/static/admin/js/admin"]
    }
  },
  npm: {
    enabled: true
  }
};
