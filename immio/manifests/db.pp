class immio::db(
){

  # Exec resource default
  Exec { 
    path    => [ '/usr/bin', '/usr/sbin', '/bin', '/sbin'], 
    timeout => 0,
  }

  #file {'/vagrant/setup.sql':
  # ensure => file,
  #}

  # Setup Postgres DB
  exec { 'initialize-db':
    command => "su - postgres -c 'plsql -f /vagrant/setup.sql'; touch /usr/local/src/.dbinitialized",
    creates => "/usr/local/src/.dbinitialized",
  }
}
