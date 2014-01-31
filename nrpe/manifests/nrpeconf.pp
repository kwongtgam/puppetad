class nrpe::nrpeconf(
  $nagiospkgs,
){
  # Extra checks depending on site
  #case $domain {
  #  'pixlr.com': { $templ = "'nrpe/nrpe_local.cfg.erb', 'nrpe/pixlr/nrpe_extra.erb'" }
  #  default:     { $templ = "'nrpe/nrpe_local.cfg.erb'" }
  #}

  file { '/etc/nagios/nrpe.cfg':
    ensure  => file,
    content => template('nrpe/nrpe.cfg.erb'),
    require => Package[ $nagiospkgs ],
  }

  file { '/etc/nagios/nrpe_local.cfg':
    ensure  => file,
    content => template('nrpe/nrpe_local.cfg.erb'),
    require => Package[ $nagiospkgs ],
  }
}
