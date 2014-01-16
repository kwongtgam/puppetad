class pixlr-app::packages(
  $dependentpkgs,
){

  #Install some packages
  package { $dependentpkgs:
    ensure => installed,
  }
}
