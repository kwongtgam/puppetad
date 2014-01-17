class pixlr-app::remoteip(
){
  # Only run this on "non-master" servers
  exportfact::export {"${hostname}_IP":
    value    => $ipaddress,
    category => "pixlr_non_master_app"
  }
}
