define pixlr-app::subdirs(
  $webuser,
  $webgroup,
){
  file { "${name}":
    ensure => directory,
    owner  => "$webuser",
    group  => "$webgroup",
  }
}
