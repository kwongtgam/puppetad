define pixlr-app::cron(
  #$cronjobs = hiera('cronjobs'),
){

  $command  = $cronjobs['command']
  $user     = $cronjobs['user']
  $hour     = $cronjobs['hour']
  $minute   = $cronjobs['minute']
  $ensure   = $cronjobs['ensure']

 notify {"Item ${name} has command ${command}, user ${user}, hour ${hour}, minute ${minute}, ensure ${ensure}": }

#  cron { $name:
#    command => $command,
#    ensure  => $ensure,
#    user    => $user,
#    hour    => $hour,
#    minute  => $minute,
#  }
}
