class util(
  $defaultpkgs = hiera('defaultpkgs')
  $pmasterip   = hiera('pmasterip')
){

  # Setup NTP - need puppetlabs/ntp module installed
  class { '::ntp': 
  }

  package { $defaultpkgs:
    ensure => installed,
  }

  # Add the pixlr puppet master IP to /etc/hosts
  host { 'pmint.pixlr.com':
    ip           => $pmasterip,
    host_aliases => [ 'puppet'],
  }

  # Setup the default editor 
  if ( $::osfamily == 'Debian' ) {
    exec { 'vim.tiny':
      path    => "/usr/bin:/usr/sbin:/bin",
      command => 'echo 2 | update-alternatives --config editor',
      unless  => 'update-alternatives --query editor | grep Value | grep -Eq "vim.tiny|vim.basic"',
    }
  }
}
