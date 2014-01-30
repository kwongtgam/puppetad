class nagiosxi(
  $nagiosparams = hiera('nagiosparams')
){
  $baseurl     = $nagiosparams['url']
  $releasever  = $nagiosparams['releasever']
  $releaseyear = $nagiosparams['releaseyear']

  $nagiosdlurl = "$baseurl/$releaseyear/$releasever.tar.gz"

  # Exec resource default
  Exec { 
    path    => [ '/usr/bin', '/usr/sbin', '/bin', '/sbin'], 
    timeout => 0,
  }

  exec { 'download-nagios-src':
    command => "curl -O $nagiosdlurl",
    cwd     => '/tmp',
    creates => "/tmp/$releasever.tar.gz",
  }

  exec { 'unpack-nagios-src':
    command => "tar -zxvf $releasever.tar.gz",
    cwd     => '/tmp',
    require => Exec['download-nagios-src'],
    creates => '/tmp/nagiosxi',
  }

  exec { 'install-nagios-from-src':
    command => "echo y | /tmp/nagiosxi/fullinstall",
    cwd     => '/tmp/nagiosxi',
    require => Exec['unpack-nagios-src'],
    creates => '/tmp/nagiosxi/install.log',
  }
}
