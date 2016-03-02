/* jshint node: true */

module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'client',
    environment: environment,
    baseURL: '/explore/',
    locationType: 'auto',
    EmberENV: {
      FEATURES: {
        // Here you can enable experimental features on an ember canary build
        // e.g. 'with-controller': true
      }
    },

    stripePublishableKey: 'pk_live_xH0VpyWMmobdSGOdZGbeEvjE', // TODO: Use env, but can't figure it out on heroku

    rollbar: {
      enabled: environment === 'production',
      accessToken: "50b70bf6e3d04779995e7a08ffcb35b7", // TODO: Use env, but can't figure it out on heroku
      captureUncaught: true,
      payload: {
        environment: environment
      }
    },

    APP: {
      // Here you can pass flags/options to your application instance
      // when it is created
      rootElement: '#app-bootstrap'
    }
  };

  if (environment === 'development') {
    // ENV.APP.LOG_RESOLVER = true;
    // ENV.APP.LOG_ACTIVE_GENERATION = true;
    ENV.APP.LOG_TRANSITIONS = true;
    ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    // ENV.APP.LOG_VIEW_LOOKUPS = true;
  }

  if (environment === 'test') {
    // Testem prefers this...
    ENV.baseURL = '/';
    ENV.locationType = 'none';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';
  }

  return ENV;
};
