define pixlr-app::gem(
  $gemver  = $rubygems['gemver'],
  $rubyver = hiera('rubyver')
){


  package { "${name}":
    ensure => "$gemver",
    provider => 'gem',
    require  => Rbenv::Compile["$rubyver"],
  }

#  notify {"Item ${name} has version ${gemver} and rubyver ${rubyver}": }

}
