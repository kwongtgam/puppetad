class pixlr-fw(
){

  # Purge any unmanaged (by Puppet) rules
  resources { "firewall":
    purge => true,
  }

  # Ensure pre/post rules are run in order
  Firewall {
    before  => Class['pixlr-fw::post'],
    require => Class['pixlr-fw::pre'],
  }

  class { ['pixlr-fw::pre', 'pixlr-fw::post']: } 
  class { 'firewall': }

  if $::domain == "pm.pixlr.com" {
    class { 'pixlr-fw::pm': }
  }

}
