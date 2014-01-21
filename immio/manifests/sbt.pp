class immio::sbt(
  $sbtparams,
){
  $version   = $sbtparams['version']
  $dlurlbase = $sbtparams['dlurlbase']
  $pkgname   = $sbtparams['pkgname']

  $sbturl = "$dlurlbase/$version/$pkgname"

  # Exec resource default
  Exec { 
    path    => [ '/usr/bin', '/usr/sbin', '/bin', '/sbin'], 
    timeout => 0,
  }

  # Download SBT Deb package
  exec { 'download-sbt':
    command => "wget $sbturl -O /opt/$pkgname ; touch /usr/local/src/.sbtdownloaded",
    creates => "/usr/local/src/.sbtdownloaded",
  }
  ->
  # Install SBT Deb package
  exec { 'install-sbt':
    command => "dpkg -i --ignore-depends=java2-runtime /opt/$pkgname ; touch /usr/local/src/.sbtdownloaded",
    unless  => "dpkg-query -l sbt",
    #creates => "/usr/local/src/.sbtdownloaded",
  }
}
