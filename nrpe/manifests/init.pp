class nrpe(
  $nagiospkgs   = hiera('nagiospkgs'),
  $nagioschecks = hiera('nagioschecks'),
){

  package { $nagiospkgs:
    ensure => installed,
  }

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

  # Call define to put in custom checks
  nrpe::checks { $nagioschecks: 
  }
}
