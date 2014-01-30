define nrpe::checks(
) {
  file { "/usr/lib/nagios/plugins/${name}":
    ensure  => file,
    content => template("nrpe/checks/${name}"), 
    mode    => 0755,
  }
}
