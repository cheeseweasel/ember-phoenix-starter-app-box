class { 'nginx': }

nginx::resource::vhost { 'www.ember-phoenix-starter-app.com':
  www_root => '/srv/www/ember-phoenix-starter-app',
}
nginx::resource::upstream { 'ember_phoenix_starter_app':
  members => [
    'localhost:3000',
    'localhost:3001',
    'localhost:3002',
  ],
}