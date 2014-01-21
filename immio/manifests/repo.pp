class immio::repo(
){
  #require configurerepo
  include apt

  # Only run this if it's a Debian based system
  if ( $osfamily == 'Debian' ) {

    # Requires the puppetlabs/apt module to be installed

    # Install the backports repo to get newer Redis version
    apt::source {'backports':
      location    => 'http://debian.cs.binghamton.edu/debian',
      repos       => 'main',
      release     => "$::lsbdistcodename-backports",
      include_src => false,
    }

    # Install the repo for Postgres
    #apt::source {'pgdg':
    #  location    => 'http://apt.postgresql.org/pub/repos/apt/',
    #  repos       => 'main',
    #  release     => "$::lsbdistcodename-pgdg",
    #  key         => 'ACCC4CF8',
    #  key_source  => 'https://www.postgresql.org/media/keys/ACCC4CF8.asc',
    #  include_src => false,
    #}

    # Install the repo for RabbitMQ
    apt::source {'rabbitmq':
      location    => 'http://www.rabbitmq.com/debian/',
      repos       => 'main',
      release     => 'testing',
      key         => '056E8E56',
      key_source  => 'http://www.rabbitmq.com/rabbitmq-signing-key-public.asc',
      include_src => false,
    }
  }
}

