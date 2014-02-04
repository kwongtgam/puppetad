class pixlr-fw::pm {

  # Specific rules for Puppetmaster
  firewall { '050 AllowHTTPS SFO':
    dport   => 443,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '132.188.71.0/24',
  }
  firewall { '051 AllowHTTPS Toronto':
    dport   => 443,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '207.61.230.154/32',
  }
  firewall { '052 AllowHTTPS AWS WOPS':
    dport   => 443,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '10.196.82.56/32',
  }
  firewall { '053 AllowHTTPS Shanghai1':
    dport   => 443,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '210.13.94.34/32',
  }
  firewall { '054 AllowHTTPS Shanghai2':
    dport   => 443,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '118.228.153.194/32',
  }
  firewall { '055 AllowHTTPS Pune1':
    dport   => 443,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '115.112.233.72/32',
  }
  firewall { '056 AllowHTTPS Pune2':
    dport   => 443,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '203.202.234.0/24',
  }
  firewall { '057 AllowHTTPS Singapore':
    dport   => 443,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '203.202.234.0/24',
  }
  firewall { '058 AllowHTTPS Internal1':
    dport   => 443,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '192.168.0.0/16',
  }
  firewall { '059 AllowHTTPS Internal2':
    dport   => 443,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '10.0.0.0/8',
    ensure  => absent,
  }
  firewall { '060 AllowHTTPS VMNet':
    dport   => 443,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '172.16.40.1/32',
  }
  firewall { '061 AllowHTTPS TorontoProxy':
    dport   => 443,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '208.100.40.39/32',
  }
  firewall { '062 Reject HTTPS':
    dport   => 443,
    proto   => tcp,
    action  => 'reject',
    reject  => 'icmp-port-unreachable',
    #ensure  => absent,
  }
}
