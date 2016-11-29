class remove (
  $winsw_binary_version    = $::winsw::params::winsw_binary_version,
  $install_path            = $::winsw::params::install_path,
  $service_id              = $::winsw::params::service_id,
) {
  winsw::install { "uninstall_myservice":
    ensure       => absent,
    install_path => $install_path,
    service_id   => $service_id,
    notify       => Winsw::Files["remove_files_myservice"],
  }

   winsw::files { "remove_files_myservice":
    ensure                  => absent,
    winsw_binary_version    => $winsw_binary_version,
    install_path            => $install_path,
    service_id              => $service_id,
  }

}