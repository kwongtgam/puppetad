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
  # Unpack SBT
  #package { 'sbt':
  #  provider => dpkg,
  #  ensure   => installed,
  #  install_options => [ '--ignore-depends=java2-runtime' ],
  #  source   => "/opt/$pkgname",
  #}
 # ->

  # Install SBT Deb package
  exec { 'install-sbt':
    command => "dpkg -i --ignore-depends=java2-runtime /opt/$pkgname ; touch /usr/local/src/.sbtdownloaded",
    unless  => "dpkg-query -l sbt",
    #creates => "/usr/local/src/.sbtdownloaded",
  }
 # ->

  # Update JDK Alternatives
 # exec { 'update-java-alt':
 #   command => "update-alternatives --install /usr/bin/java java /opt/${unpackdir}/bin/java 20000",
 #   unless  => "test -f /usr/bin/java",
 # }
}
