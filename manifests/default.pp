class { 'apt': }

package { [
    'build-essential',
    'vim',
    'curl',
    'zsh',
    'git-core',
    'esl-erlang',
  ]:
  ensure  => 'installed',
}

package { 'elixir':
  require => package['esl-erlang']
}

exec { 'install-hex-phoenix':
  command => 'mix local.hex --force && mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force',
  require => package['elixir'],
  user => 'vagrant',
  logoutput => 'true',
  environment => ["HOME=/home/vagrant"],
  path => ['/usr/bin', '/usr/local/bin', '/usr/bin/erl', '/usr/bin/X11/erl', '/usr/bin/X11', '/bin'],
}

class { 'nginx': }

nginx::resource::vhost { 'client':
  listen_port => 80,
  proxy => 'http://localhost:4200/',
}
nginx::resource::vhost { 'server':
  listen_port => 4000,
  www_root => '/srv/www/ember-phoenix-starter-app/server',
}
nginx::resource::upstream { 'ember_phoenix_starter_app':
  members => [
    'localhost:3000',
    'localhost:3001',
    'localhost:3002',
  ],
}

class { 'postgresql::server': }
  
postgresql::server::role { 'postgres':
  password_hash => postgresql_password('postgres', 'postgres'),
  createdb  => true
}
  
postgresql::server::db { 'phoenix_development':
  user     => 'postgres',
  password => postgresql_password('postgres', 'postgres'),
}
  
postgresql::server::db { 'phoenix_test':
  user     => 'postgres',
  password => postgresql_password('postgres', 'postgres'),
}

