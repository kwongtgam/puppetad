class immio::repo(
){

  # Only run this if it's a Debian based system
  if ( $osfamily == 'Debian' ) {

    # Requires the puppetlabs/apt module to be installed

    # Install the backports repo
    apt::source {'backports':
      location    => 'http://debian.cs.binghamton.edu/debian',
      repos       => 'main',
      release     => 'wheezy-backports',
      include_src => false,
    }

    # Install the repo for RabbitMQ
    apt::source {'rabbitmq':
      location    => 'http://www.rabbitmq.com/debian/',
      repos       => 'main',
      release     => 'testing',
      key_source  => 'http://www.rabbitmq.com/rabbitmq-signing-key-public.asc',
      include_src => false,
    }
  }
}

