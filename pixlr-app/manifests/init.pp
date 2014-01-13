class pixlr-app (
  $rubyver       = hiera('rubyver'),
  $rubygems      = hiera('rubygems'),
  $rbenvuser     = hiera('rbenvuser'),
  $nginxparams   = hiera('nginxparams'),
  $nginxvhosts   = hiera('nginxvhosts'),
  $dependentpkgs = hiera('dependentpkgs'),
  $subdirs       = hiera('subdirs'),
){

  $webuser   = $nginxparams['user']
  $webgroup  = $nginxparams['group']
  $webgid    = $nginxparams['gid']
  $webpass   = $nginxparams['password']
  $nginxconf = $nginxparams['conffile']
  $rbenvpath = "/${rbenvuser}/.rbenv/versions/$rubyver/bin"

  group { "$webgroup":
    ensure => present,
    gid    => "$webgid",
  }

  user { "$webuser":
    ensure     => present,
    gid        => "$webgroup",
    managehome => 'true',
    password   => "$webpass",
    require    => Group["$webgroup"],
  }

  #Install some packages
  package { $dependentpkgs:
    ensure => installed,
  }

  # Install rbenv
  rbenv::install { "$rbenvuser":
    group => "$rbenvuser",
    home  => "/$rbenvuser",
  }

  # Install ruby version
  rbenv::compile { "$rubyver":
    user    => "$rbenvuser",
    home    => "/$rbenvuser",
    global  => "true",
    require => Rbenv::Install ["$rbenvuser"],
  }

  # Install other gems
  create_resources(gem, $rubygems)

  # Install/compile Phusion Passenger with Nginx
  exec { 'passenger-install-nginx':
    command => "passenger-install-nginx-module --auto --auto-download --prefix=/opt/nginx; touch /opt/phusion-installed",
    creates => "/opt/phusion-installed",
    path    => [ "${rbenvpath}", '/usr/bin', '/usr/sbin', '/bin', '/sbin'],
    require => Package['passenger'],
  }

  # Create Subdirs
  pixlr-app::subdirs { $subdirs:
    webuser  => $webuser,
    webgroup => $webgroup,
  }

  # Generate the proper Nginx conf files by concatenating fragments
  concat { $nginxconf: }
  create_resources(vhost, $nginxvhosts, $nginxparams)
}
