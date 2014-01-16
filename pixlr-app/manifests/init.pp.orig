class pixlr-app (
  $rubyver         = hiera('rubyver'),
  $rubygems        = hiera('rubygems'),
  $nginxparams     = hiera('nginxparams'),
  $nginxvhosts     = hiera('nginxvhosts'),
  $dependentpkgs   = hiera('dependentpkgs'),
  $passengerparams = hiera('passengerparams'),
  $subdirs         = hiera('subdirs'),
){
 
  require configurerepo

  # Pull out hash parameters
  $webuser      = $nginxparams['user']
  $webgroup     = $nginxparams['group']
  $webgid       = $nginxparams['gid']
  $webpass      = $nginxparams['password']
  $nginxconf    = $nginxparams['conffile']
  $rbenvpath    = "/home/${webuser}/.rbenv/versions/$rubyver/bin"
  #$maxpoolsize  = $passengerparams['max_pool_size']
  #$mininstances = $passengerparams['min_instances']
  #$poolidletime = $passengerparams['pool_idle_time']
  #$buffers      = $passengerparams['buffers']
  #$buffersize   = $passengerparams['buffer_size']
  #$bufferresp   = $passengerparams['buffer_response']

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

  # Add subversion authentication
  file { "/home/${webuser}/.subversion":
    ensure => directory,
    owner  => $webuser,
    group  => $webgroup,
    source => 'puppet:///modules/pixlr-app/pixlr/.subversion',
    recurse => true,
    require => User["$webuser"], 
  }

  #Install some packages
  package { $dependentpkgs:
    ensure => installed,
  }

  # Install rbenv using alup/puppet-rbenv moudule from forge.puppetlabs.com
  rbenv::install { "$webuser":
    group => "$webgroup",
  }

  # Install ruby version
  rbenv::compile { "$rubyver":
    user    => "$webuser",
    group   => "$webgroup",
    global  => "true",
    require => Rbenv::Install ["$webuser"],
  }

  # Install other gems (only Passenger for now) under $webuser dir
  create_resources(gem, $rubygems)

  # Create Subdirs
  pixlr-app::subdirs { $subdirs:
    webuser  => $webuser,
    webgroup => $webgroup,
  }

  # Checkout codebase from SVN
  exec { 'svncheckout-pixlr':
    command => "su - ${webuser} -c 'cd /var/www/pixlr; svn checkout https://pixlr.svn.beanstalkapp.com/web/trunk .; bundle install'",
    path    => [ '/usr/bin', '/usr/sbin', '/bin', '/sbin'],
    unless  => "test -f /var/www/pixlr/config/routes.rb",
    require => [ File["/home/${webuser}/.subversion"], File['/var/www/pixlr'] ],
  }

  file { "/tmp/pixlrbin.tar.gz":
    ensure => file,
    source => 'puppet:///modules/pixlr-app/pixlrbin.tar.gz',
  }

  # Add public SWF files after SVN checkout
  exec { 'install-binary-files':
    command => "su - ${webuser} -c 'cd /var/www/pixlr/public; tar -zxvf /tmp/pixlrbin.tar.gz'",
    unless  => "test -f /var/www/pixlr/public/editor/editor.swf",
    timeout => 0,
    path    => [ '/usr/bin', '/usr/sbin', '/bin', '/sbin'],
    require => Exec['svncheckout-pixlr'],
  }

  # Install/compile Phusion Passenger with Nginx
  exec { 'passenger-install-nginx':
    command => "su - ${webuser} -c 'passenger-install-nginx-module --auto --auto-download --prefix=/opt/nginx; touch /home/${webuser}/phusion-installed'",
    creates => "/home/${webuser}/phusion-installed",
    timeout => 0,
    path    => [ "${rbenvpath}", '/usr/bin', '/usr/sbin', '/bin', '/sbin'],
    require => [ Exec['passenger'], File['/opt/nginx'] ],
  }

  # Add SSL Key/Certs
  file { '/etc/ssl/certs/2014.pixlr.com.crt':
    ensure => file,
    source => 'puppet:///modules/pixlr-app/2014.pixlr.com.crt',
  }

  file { '/etc/ssl/certs/pixlr.com.key':
    ensure => file,
    source => 'puppet:///modules/pixlr-app/pixlr.com.key',
  }

  # Generate the proper Nginx conf files by concatenating fragments
  concat { $nginxconf: }
  create_resources(vhost, $nginxvhosts, $nginxparams)

  # Put the nginx startup script
  file { '/etc/init.d/nginx':
    ensure  => file,
    mode    => 0766,
    content => template('pixlr-app/nginx/nginx.erb'),
  }

  # Startup nginx once config is done
  service { 'nginx':
    ensure    => running,
    enable    => true,
    subscribe => File["$nginxconf"],
    require   => File['/etc/init.d/nginx'],
  }
}
