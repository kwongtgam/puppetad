class pixlr-app::repo(
){
  # Requires the puppetlabs/apt module to be installed (default on Puppet Enterprise)
  include apt

  # Only run this if it's a Debian based system
  if ( $osfamily == 'Debian' ) {


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
