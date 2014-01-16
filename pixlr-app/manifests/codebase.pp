class pixlr-app::codebase(
  $webuser,
  $webgroup,
  $subdirs,
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
}
