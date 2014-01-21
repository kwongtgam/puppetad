class util(
){
  # Setup the default editor 
  if ( $::osfamily == 'Debian' ) {
    exec { 'vim.tiny':
      path    => "/usr/bin:/usr/sbin:/bin",
      command => 'echo 2 | update-alternatives --config editor',
      unless  => 'update-alternatives --query editor | grep Value | grep -Eq "vim.tiny|vim.basic"',
    }
  }
}
