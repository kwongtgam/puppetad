define pixlr-app::scripts {
  file { "/root/${name}":
    ensure  => file,
    mode    => '0766',
    owner   => 'root',
    content => template("pixlr-app/scripts/${name}.erb"),
  }
}
