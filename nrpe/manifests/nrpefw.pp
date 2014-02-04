class nrpe::nrpefw(
){

  firewall { '009 Nrpe Local':
    dport   => 5666,
    proto   => tcp,
    chain   => INPUT,
    action  => 'accept',
    source  => '172.16.0.0/12',
  }
}
