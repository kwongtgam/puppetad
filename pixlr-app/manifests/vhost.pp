define pixlr-app::vhost(
  $gid,
  $password,
  $user            = $nginxparams['user'],
  $group           = $nginxparams['group'],
  $conffile        = $nginxparams['conffile'],
  $listenport      = $nginxvhosts['listenport'],
  $docroot         = $nginxvhosts['docroot'],
  $server_name     = $nginxvhosts['server_name'],
  $order           = $nginxvhosts['order'],
  $rubyver         = hiera('rubyver'),
  $gems            = hiera('rubygems'),
  $passengerparams = hiera('passengerparams'),
){

  # Setup some local variables used by templates
  $passengerver  = $gems['passenger']['gemver']
  $passengerroot = "/home/${user}/.rbenv/versions/${rubyver}/lib/ruby/gems/2.0.0/gems/passenger-${passengerver}"
  $passengerruby = "/home/${user}/.rbenv/versions/${rubyver}/bin/ruby"
  $maxpoolsize   = $passengerparams['max_pool_size']
  $mininstances  = $passengerparams['min_instances']
  $poolidletime  = $passengerparams['pool_idle_time']
  $buffers       = $passengerparams['buffers']
  $buffersize    = $passengerparams['buffer_size']
  $bufferresp    = $passengerparams['buffer_response']

  # For debugging only
  #notify { "Item ${name}, passengerver ${passengerver}, passengerpath ${passengerpath}, passengerruby  ${passengerruby }, maxpoolsize ${maxpoolsize}, mininstances ${mininstances}, poolidletime ${poolidletime} ": }

  concat::fragment{ "${name}":
    target  => "${conffile}",
    content => template("pixlr-app/nginx/conf/pixlr-vhost-${name}.erb"),
    order   => "${order}",
    require => Exec['passenger-install-nginx']
  }
}
