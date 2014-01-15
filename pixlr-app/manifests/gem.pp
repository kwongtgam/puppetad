define pixlr-app::gem(
  $rubyver     = hiera('rubyver'),
  $gemver      = $rubygems['gemver'],
  $nginxparams = hiera('nginxparams'),
){

  $webuser = $nginxparams['user']

  exec { "${name}":
    command => "su - ${webuser} -c 'gem install ${name} -v ${gemver}'",
    path    => [ "/home/${webuser}/.rbenv/shims", '/usr/bin', '/usr/sbin', '/bin', '/sbin'],
    creates => "/home/${webuser}/.rbenv/versions/${rubyver}/bin/${name}",
    require  => Rbenv::Compile["$rubyver"],
  }

  #package { "${name}":
  #  ensure => "$gemver",
  #  provider => 'gem',
  #  require  => Rbenv::Compile["$rubyver"],
  #}

  #notify {"Item ${name} has version ${gemver} and rubyver ${rubyver} and user ${webuser}": }
}
