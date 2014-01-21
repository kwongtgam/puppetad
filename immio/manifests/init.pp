class immio(
  $javaparams    = hiera('javaparams'),
  $sbtparams     = hiera('sbtparams'),
  $sbtconfigopts = hiera('sbtconfigopts'),
  $immiopkgs     = hiera('immiopkgs'),
){
  require util

  # Call the sub-class to add the repositories
  class {'immio::repo':
  }

  # Call the sub-class to install the req'd packages
  class {'immio::packages':
    immiopkgs  => $immiopkgs,
  }

  # Call the sub-class to download/install Java from Oracle
  class {'immio::java':
    javaparams  => $javaparams,
  }

  # Call the sub-class to download/install SBT
  class {'immio::sbt':
    sbtparams     => $sbtparams,
    sbtconfigopts => $sbtconfigopts,
  }

  # Order the resources
  Class['immio::repo'] -> Class['immio::packages'] -> Class['immio::java'] -> Class['immio::sbt']

}
