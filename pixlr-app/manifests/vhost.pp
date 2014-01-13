define pixlr-app::vhost(
  $user,
  $group,
  $gid,
  $password,
  $conffile    = $nginxparams['conffile'],
  $listenport  = $nginxvhosts['listenport'],
  $docroot     = $nginxvhosts['docroot'],
  $server_name = $nginxvhosts['server_name'],
  $order       = $nginxvhosts['order'],
){

  # For debugging only
  #notify { "Using ${conffile}, Item ${name} has docroot ${docroot}, server_name ${server_name}, order of ${order} and listenport of ${listenport}": }

  # Generate the proper Nginx conf files by concatenating fragments
  #concat { $nginxconf: }

  concat::fragment{ "${name}":
    target  => "${conffile}",
    content => template("pixlr-app/nginx/conf/pixlr-vhost-${name}.erb"),
    order   => "${order}",
    require => Exec['passenger-install-nginx']
  }
}
