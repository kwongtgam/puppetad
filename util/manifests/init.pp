class util(
  $defaultpkgs  = hiera('defaultpkgs'),
  $pmasterip    = hiera('pmasterip'),
  $pmasterecsip = hiera('pmasterecsip'),
){

  # Setup NTP - need puppetlabs/ntp module installed
  class { '::ntp': 
  }

  package { $defaultpkgs:
    ensure => installed,
  }

  if ( $::hostname =~ /(app)\d+$/ and $::domain =~ /pixlr.com/ ) {
    # Add the pixlr puppet master IP to /etc/hosts
    host { 'pmint.pixlr.com':
      ip           => $pmasterip,
      host_aliases => [ 'puppet', 'puppet.pixlr.com', 'pmint'],
    }
  } else {
    # Add the ECS puppet master IP to /etc/hosts
    host { 'ecs-a02b4654.ecs.ads.autodesk.com':
      ip           => $pmasterecsip,
      host_aliases => [ 'puppet', 'pmint'],
    }
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
