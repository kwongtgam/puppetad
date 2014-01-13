class pixlr-app::passnginx {

  # Install & compile passenger/nginx
  exec { 'passenger-install-nginx':
    command => "passenger-install-nginx-module --auto --auto-download; touch /opt/passenger-installed",
    creates => "/opt/passenger-installed",
    path    => ['/usr/bin', '/usr/sbin', '/bin', '/sbin'],
    require => Package['passenger'],
  }
}
