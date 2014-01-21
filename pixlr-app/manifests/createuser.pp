class pixlr-app::createuser(
  $webuser,
  $webgroup,
  $webgid,
  $webpass,
  $pixlrappmaster,
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

  if $pixlrappmaster =~ /true/ {

    # Copy the keys from Linode app1
    file { "/root/.ssh":
      ensure  => directory,
      source  => 'puppet:///modules/pixlr-app/root/.ssh', 
      recurse => true,
      owner   => root,
      group   => root,
      mode    => 0700,
    }

  } else {

    file { "/home/$webuser/.ssh":
      ensure  => directory,
      owner   => $webuser,
      group   => $webgroup,
      mode    => 0600,
      require => User["$webuser"],
    }
    
    file { "/home/$webuser/.ssh/authorized_keys":
      ensure  => file,
      owner   => $webuser,
      group   => $webgroup,
      mode    => 0600,
      source  => 'puppet:///modules/pixlr-app/pixlr/.ssh/authorized_keys',
      require => File["/home/$webuser/.ssh"],
    }
  } # end pixlrappmaster condition

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
