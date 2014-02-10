class balder-app::rails(
  $webuser,
  $rbenvpath,
){
  # Generate a clean rails app
  exec { 'generate-balder-rails-app':
    command => "su - ${webuser} -c 'rails new /var/www/balder; touch /home/${webuser}/rails-app-installed'",
    creates => "/home/${webuser}/rails-app-installed",
    timeout => 0,
    path    => [ "${rbenvpath}", '/usr/bin', '/usr/sbin', '/bin', '/sbin'],
  }

  file { '/var/www/bundler/public/index.html':
    ensure  => file,
    content => "Contents of /var/www/balder/public/index.html.  Change config/routes.rb to point to correct page",
    require => Exec['generate-balder-rails-app'],
  }
}
