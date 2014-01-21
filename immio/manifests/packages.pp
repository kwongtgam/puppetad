class immio::packages(
  $immiopkgs,
){

  #Install some packages
  package { $immiopkgs:
    ensure => installed,
  }
}
