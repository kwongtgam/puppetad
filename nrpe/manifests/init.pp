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

    # Startup nginx once config is done
  service { 'nagios-nrpe-server':
    ensure    => running,
    enable    => true,
    subscribe => [ File['/etc/nagios/nrpe.cfg'], File['/etc/nagios/nrpe_local.cfg']],
    require   => [ 
      Package[ $nagiospkgs ], 
      File[ '/etc/nagios/nrpe.cfg' ],
      File[ '/etc/nagios/nrpe_local.cfg' ],
    ],
  }
}
