class { 'apt': }

package { [
    'build-essential',
    'vim',
    'curl',
    'zsh',
    'git-core'
  ]:
  ensure  => 'installed',
}

package { 'erlang':
  ensure => '1:18.1',
}

package { 'elixir':
  ensure => '1.1.0-1',
}

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

class { 'postgresql::server': }