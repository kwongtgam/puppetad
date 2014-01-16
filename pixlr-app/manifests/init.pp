class pixlr-app (
  $rubyver         = hiera('rubyver'),
  $rubygems        = hiera('rubygems'),
  $nginxparams     = hiera('nginxparams'),
  $nginxvhosts     = hiera('nginxvhosts'),
  $dependentpkgs   = hiera('dependentpkgs'),
  $passengerparams = hiera('passengerparams'),
  $subdirs         = hiera('subdirs'),
  $pixlrscripts    = hiera('pixlrscripts'),
  $cronjobs        = hiera('cronjobs'),
){
 
  require configurerepo

  # Pull out hash parameters
  $webuser      = $nginxparams['user']
  $webgroup     = $nginxparams['group']
  $webgid       = $nginxparams['gid']
  $webpass      = $nginxparams['password']
  $nginxconf    = $nginxparams['conffile']
  $rbenvpath    = "/home/${webuser}/.rbenv/versions/$rubyver/bin"

  # Call the sub-class to create the user & group
  class {'pixlr-app::createuser':
    webuser  => $webuser,
    webgroup => $webgroup,
    webgid   => $webgid,
    webpass  => $webpass,
  }

  # Call define class to add scripts
  pixlr-app::scripts { $pixlrscripts:
  }

  # Call the create_resources function to add the cron jobs
  create_resources(cron, $cronjobs)

  # Call the sub-class to install some dependent packages
  class {'pixlr-app::packages':
    dependentpkgs  => $dependentpkgs,
  }

  # Call the sub-class to install rbenv and gems
  class {'pixlr-app::rbenv':
    webuser  => $webuser,
    webgroup => $webgroup,
    rubyver  => $rubyver,
    rubygems => $rubygems,
  }

  # Call the sub-class to checkout from SVN, run bundle install and copy binary files
  class {'pixlr-app::codebase':
    webuser     => $webuser,
    webgroup    => $webgroup,
    subdirs     => $subdirs,
  }

  # Call the sub-class to compile/install Nginx with Phusion Passenger
  class {'pixlr-app::nginx':
    webuser     => $webuser,
    webgroup    => $webgroup,
    rbenvpath   => $rbenvpath,
    nginxconf   => $nginxconf,
    nginxvhosts => $nginxvhosts,
    nginxparams => $nginxparams,
  }

  # Order the classes
  Class['pixlr-app::createuser'] -> Class['pixlr-app::packages'] -> Class['pixlr-app::rbenv'] -> Class['pixlr-app::codebase'] -> Class['pixlr-app::nginx']
}
