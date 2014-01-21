class immio::java(
  $javaparams,
){

# http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.tar.gz
  $version   = $javaparams['version']
  $build     = $javaparams['build']
  $jdkdir    = $javaparams['jdkdir']
  $dlurlbase = $javaparams['dlurlbase']
  $os        = $javaparams['os']
  $unpackdir = $javaparams['unpackdir']

  $jdkurl = "$dlurlbase/$version-$build/jdk-$version-$os.tar.gz"

  # Exec resource default
  Exec { 
    path    => [ '/usr/bin', '/usr/sbin', '/bin', '/sbin'], 
    timeout => 0,
  }

  # Download JDK from Oracle
  exec { 'download-java':
    command => "wget --no-cookies --header 'Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com' --no-check-certificate $jdkurl -O /opt/${unpackdir}.tar.gz ; touch /usr/local/src/.javadownloaded",
    creates => "/usr/local/src/.javadownloaded",
  }
  ->
  # Unpack JDK
  exec { 'unpack-java':
    command => "tar zxvf ${unpackdir}.tar.gz -C /opt/ ; touch /usr/local/src/.javainstalled",
    cwd     => "/opt",
    creates => "/usr/local/src/.javainstalled",
  }
  ->
  # Chown JDK
  exec { 'change-java-permissions':
    command => "chown -R root:root /opt/${unpackdir}",
    onlyif  => "test `stat -c %U /opt/${unpackdir}/bin/java` != root",
  }
  ->
  # Update JDK Alternatives
  exec { 'update-java-alt':
    command => "update-alternatives --install /usr/bin/java java /opt/${unpackdir}/bin/java 20000",
    unless  => "test -f /usr/bin/java",
  }
  ->
  # Update Javac Alternatives
  exec { 'update-javac-alt':
    command => "update-alternatives --install /usr/bin/javac javac /opt/${unpackdir}/bin/javac 20000",
    unless  => "test -f /usr/bin/javac",
  }
}
