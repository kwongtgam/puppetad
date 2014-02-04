class pixlr-fw::pre {
  Firewall {
    require => undef,
  }

  # Default firewall rules
  firewall { '001 accept all to lo interface':
    proto   => 'all',
    iniface => 'lo',
    action  => 'accept',
  }
  firewall { '002 accept related established rules':
    proto   => 'all',
    state   => ['RELATED', 'ESTABLISHED'],
    action  => 'accept',
  }
  firewall { '010 Nrpe SFO':
    dport   => 5666,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '132.188.71.0/24',
  }
  firewall { '011 Nrpe AWS':
    dport   => 5666,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '54.226.51.139/32',
  }
  firewall { '012 Reject NRPE':
    dport   => 5666,
    proto   => tcp,
    action  => 'reject',
    reject  => 'icmp-port-unreachable',
  }
  firewall { '013 AllowSSH SFO':
    dport   => 22,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '132.188.71.0/24',
  }
  firewall { '014 AllowSSH Toronto':
    dport   => 22,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '207.61.230.154/32',
  }
  firewall { '015 AllowSSH AWS WOPS':
    dport   => 22,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '10.196.82.56/32',
  }
  firewall { '016 AllowSSH Shanghai1':
    dport   => 22,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '210.13.94.34/32',
  }
  firewall { '017 AllowSSH Shanghai2':
    dport   => 22,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '118.228.153.194/32',
  }
  firewall { '018 AllowSSH Pune1':
    dport   => 22,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '115.112.233.72/32',
  }
  firewall { '019 AllowSSH Pune2':
    dport   => 22,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '203.202.234.0/24',
  }
  firewall { '020 AllowSSH Singapore':
    dport   => 22,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '203.202.234.0/24',
  }
  firewall { '021 AllowSSH Internal1':
    dport   => 22,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '192.168.0.0/16',
  }
  firewall { '022 AllowSSH Internal2':
    dport   => 22,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '10.0.0.0/8',
    ensure  => absent,
  }
  firewall { '023 AllowSSH Laptop':
    dport   => 22,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '10.142.212.23',
  }
  firewall { '023 AllowSSH VMNet':
    dport   => 22,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '172.16.40.1/32',
  }
  firewall { '030 Reject SSH':
    dport   => 22,
    proto   => tcp,
    action  => 'reject',
    reject  => 'icmp-port-unreachable',
    #ensure  => absent,
  }
}
