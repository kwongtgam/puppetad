define balder-app::scripts(
  $pixlrappslaves,
){
  file { "/root/${name}":
    ensure  => file,
    mode    => '0766',
    owner   => 'root',
    content => template("balder-app/scripts/${name}.erb"),
  }
}
