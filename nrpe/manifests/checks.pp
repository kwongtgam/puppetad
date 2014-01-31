define nrpe::checks(
  $checkdir,
) {
  file { "$checkdir/${name}":
    ensure  => file,
    content => template("nrpe/checks/${operatingsystem}/${name}"), 
    mode    => 0755,
  }
}
