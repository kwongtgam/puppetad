class pixlr-app::repo(
){
  # Requires the puppetlabs/apt module to be installed (default on Puppet Enterprise)
  include apt

  # Only run this if it's a Debian based system
  if ( $osfamily == 'Debian' ) {

    # Only install this repo on the Mongo servers
    if  $::hostname =~ /(mongo|db)\d+/  {
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

    # Install the repo for Postgres
    apt::source {'pgdg':
      location    => 'http://apt.postgresql.org/pub/repos/apt/',
      repos       => 'main',
      release     => "$::lsbdistcodename-pgdg",
      key         => 'ACCC4CF8',
      key_source  => 'https://www.postgresql.org/media/keys/ACCC4CF8.asc',
      include_src => false,
    }
  }
}
