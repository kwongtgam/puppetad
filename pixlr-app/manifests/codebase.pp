class pixlr-app::codebase(
  $webuser,
  $webgroup,
  $subdirs,
  $pixlrmongodb,
  $pixlrmongodbport,
){

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

  file { "/usr/local/src/pixlrbin.tar.gz":
    ensure => file,
    source => 'puppet:///modules/pixlr-app/pixlrbin.tar.gz',
  }

  # Overwrite mongoid.yml file from SVN
  file { "/var/www/pixlr/config/mongoid.yml":
    ensure  => file,
    content => template('pixlr-app/mongoid.yml.erb'),
    notify  => Service['nginx'],
  }

  # Add public SWF files after SVN checkout
  exec { 'install-binary-files':
    command => "su - ${webuser} -c 'cd /var/www/pixlr/public; tar -zxvf /usr/local/src/pixlrbin.tar.gz'",
    unless  => "test -f /var/www/pixlr/public/editor/editor.swf",
    timeout => 0,
    path    => [ '/usr/bin', '/usr/sbin', '/bin', '/sbin'],
    require => [ Exec['svncheckout-pixlr'], File['/usr/local/src/pixlrbin.tar.gz'] ],
  }

  # FOR IMMIO
  file { '/var/www/immio/index.html':
    ensure  => file,
    content => template('pixlr-app/immio/index.html.erb'),
    require => File['/var/www/immio'],
  }
}
