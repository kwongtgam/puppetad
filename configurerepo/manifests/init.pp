class configurerepo {

  # Only run this if it's a Debian based system
  if ( $osfamily == 'Debian' ) {

    # Requires the puppetlabs/apt module to be installed

    if ($::hostname =~ /(mongo|mongodb|db)\d+/ or $::virtual =~ /virtualbox/) {
      # Install the 10th gen repo for MongoDB
      apt::source {'10gen':
        location    => 'http://downloads-distro.mongodb.org/repo/debian-sysvinit',
        repos       => '10gen',
        release     => 'dist',
        key         => '7F0CEB10',
        key_server  => 'keyserver.ubuntu.com',
        include_src => false,
      }
    }

    # Install the repo for Nagios
    apt::source {'nagiosinc':
      location    => 'http://ppa.launchpad.net/nagiosinc/ppa/ubuntu',
      repos       => 'main',
      release     => 'lucid',
      key         => 'B18637BB5175BC68',
      key_server  => 'keyserver.ubuntu.com',
      include_src => false,
    }
  }
}
