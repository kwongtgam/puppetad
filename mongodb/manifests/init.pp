class mongodb {
  require configurerepo

  package { 'mongodb-10gen':
    ensure => 'installed',
  }

  file { '/etc/mongodb.conf':
    ensure => 'file',
    content => template('mongodb/conf/mongodb.conf'),
    require => Package['mongodb-10gen'],
  }

  service { 'mongodb':
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/mongodb.conf'],
  }
}
