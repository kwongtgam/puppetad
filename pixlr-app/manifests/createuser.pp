class pixlr-app::createuser(
  $webuser,
  $webgroup,
  $webgid,
  $webpass,
){

  # Create the group that the web server will run as
  group { "$webgroup":
    ensure => present,
    gid    => "$webgid",
  }

  # Create the user that the web server will run as
  user { "$webuser":
    ensure     => present,
    gid        => "$webgroup",
    managehome => 'true',
    shell      => '/bin/bash',
    password   => "$webpass",
    require    => Group["$webgroup"],
  }

  file { "/home/$webuser/.ssh":
    ensure  => directory,
    owner   => $webuser,
    group   => $webgroup,
    mode    => 0644,
    require => User["$webuser"],
  }
    
  file { "$webuser/.ssh/authorized_keys":
    ensure  => file,
    owner   => $webuser,
    group   => $webgroup,
    mode    => 0644,
    source  => 'puppet:///modules/pixlr-app/authorized_keys',
    require => File["/home/$webuser/.ssh"],
  }

  # Add subversion authentication
  file { "/home/${webuser}/.subversion":
    ensure => directory,
    owner  => $webuser,
    group  => $webgroup,
    source => 'puppet:///modules/pixlr-app/pixlr/.subversion',
    recurse => true,
    require => User["$webuser"],
  }
}
