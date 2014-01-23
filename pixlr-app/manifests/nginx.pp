class pixlr-app::nginx(
  $webuser,
  $webgroup,
  $rbenvpath,
  $nginxconf,
  $nginxvhosts,
  $nginxparams,
){

  Concat {
    owner => $webuser,
    group => $webgroup,
  }

  # Install/compile Phusion Passenger with Nginx
  exec { 'passenger-install-nginx':
    command => "su - ${webuser} -c 'passenger-install-nginx-module --auto --auto-download --prefix=/opt/nginx; touch /home/${webuser}/phusion-installed'",
    creates => "/home/${webuser}/phusion-installed",
    timeout => 0,
    path    => [ "${rbenvpath}", '/usr/bin', '/usr/sbin', '/bin', '/sbin'],
    require => [ Exec['passenger'], File['/opt/nginx'] ],
  }

  # Add SSL Key/Certs
  file { '/etc/ssl/certs/2014.pixlr.com.crt':
    ensure => file,
    source => 'puppet:///modules/pixlr-app/2014.pixlr.com.crt',
  }

  file { '/etc/ssl/certs/pixlr.com.key':
    ensure => file,
    source => 'puppet:///modules/pixlr-app/pixlr.com.key',
  }

  # Generate the proper Nginx conf files by concatenating fragments
  concat { $nginxconf: }
  create_resources(vhost, $nginxvhosts, $nginxparams)

  # Put the nginx startup script
  file { '/etc/init.d/nginx':
    ensure  => file,
    mode    => 0766,
    content => template('pixlr-app/nginx/nginx.erb'),
  }

  # Startup nginx once config is done
  service { 'nginx':
    ensure    => running,
    enable    => true,
    subscribe => File["$nginxconf"],
    require   => File['/etc/init.d/nginx'],
  }
}
