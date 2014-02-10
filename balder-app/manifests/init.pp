class balder-app (
  $rubyver          = hiera('rubyver'),
  $rubygems         = hiera('rubygems'),
  $nginxparams      = hiera('nginxparams'),
  $nginxvhosts      = hiera('nginxvhosts'),
  $dependentpkgs    = hiera('dependentpkgs'),
  $passengerparams  = hiera('passengerparams'),
  $subdirs          = hiera('subdirs'),
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
  class {'balder-app::createuser':
    webuser        => $webuser,
    webgroup       => $webgroup,
    webgid         => $webgid,
    webpass        => $webpass,
  }

  # Call the sub-class to install the Deb repositories
  class {'balder-app::repo':
  }
    
  # Call the sub-class to install some dependent packages
  class {'balder-app::packages':
    dependentpkgs  => $dependentpkgs,
  }

  # Call the sub-class to install rbenv and gems
  class {'balder-app::rbenv':
    webuser  => $webuser,
    webgroup => $webgroup,
    rubyver  => $rubyver,
    rubygems => $rubygems,
  }

  # Call the sub-class to compile/install Nginx with Phusion Passenger
  class {'balder-app::nginx':
    webuser     => $webuser,
    webgroup    => $webgroup,
    rbenvpath   => $rbenvpath,
    nginxconf   => $nginxconf,
    nginxvhosts => $nginxvhosts,
    nginxparams => $nginxparams,
    subdirs     => $subdirs,
  }

  # Call the sub-class to generate a default Rails app
  class {'balder-app::rails':
    webuser     => $webuser,
    rbenvpath   => $rbenvpath,
  }

  # Order the classes
  Class['balder-app::createuser'] -> Class['balder-app::repo'] -> Class['balder-app::packages'] -> Class['balder-app::rbenv'] -> Class['balder-app::nginx'] -> Class['balder-app::rails']
}
