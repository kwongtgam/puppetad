class nrpe(
  $nagiospkgs   = hiera('nagiospkgs'),
  $nagioschecks = hiera('nagioschecks'),
  $nrpeparams   = hiera('nrpeparams'),
  $nrpehosts    = hiera('nrpehosts'),
){

  $checkdir     = $nrpeparams['checkdir']
  $startscript  = $nrpeparams['startscript']
  $allowedhosts = $nrpeparams['allowedhosts']

  package { $nagiospkgs:
    ensure => installed,
  }
  ->
  # Configure NRPE firewall
  class {'nrpe::nrpefw':
  }
  ->
  # Configure local NRPE checks and config
  class {'nrpe::nrpeconf':
    nagiospkgs => $nagiospkgs,
    nrpehosts  => $nrpehosts,
  }
  ->
  # Call define to put in custom checks
  nrpe::checks { $nagioschecks: 
    checkdir => $checkdir,
  }

  # Restart nrpe if any changes
  service { $startscript:
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
