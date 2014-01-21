class immio(
  $javaparams = hiera('javaparams'),
  $sbtparams  = hiera('sbtparams'),
  #$immiopkgs  = hiera('immiopkgs'),
){

  # Call the sub-class to add the repositories
  class {'immio::repo':
  }

  # Call the sub-class to download/install Java from Oracle
  class {'immio::java':
    javaparams  => $javaparams,
  }

  # Call the sub-class to download/install SBT
  class {'immio::sbt':
    sbtparams  => $sbtparams,
  }

  # Call the sub-class to install the req'd packages
  #class {'immio::packages':
  #  immiopkgs  => $immiopkgs,
  #}

  # Order the resources
  #Class['immio::repo'] -> Class['immio::java'] -> Class['immio::sbt'] -> Class'[immio::packages']
  Class['immio::repo'] -> Class['immio::java'] -> Class['immio::sbt']

}
