class pixlr-app::rbenv(
  $webuser,
  $webgroup,
  $rubyver,
  $rubygems,
){

  # Install rbenv using alup/puppet-rbenv moudule from forge.puppetlabs.com
  rbenv::install { "$webuser":
    group => "$webgroup",
  }

  # Install ruby version
  rbenv::compile { "$rubyver":
    user    => "$webuser",
    group   => "$webgroup",
    global  => "true",
    require => Rbenv::Install ["$webuser"],
  }

  # Install other gems (only Passenger for now) under $webuser dir
  create_resources(gem, $rubygems)
}
