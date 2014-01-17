class immio(
  $javaparams = hiera('javaparams'),
){

  # Call the sub-class to add the repositories
  class {'immio::repo':
  }

  # Call the sub-class to download/install Java from Oracle
  class {'immio::java':
    javaparams  => $javaparams,
  }

  # Order the resources
  Class['immio::repo'] -> Class['immio::java']

}
