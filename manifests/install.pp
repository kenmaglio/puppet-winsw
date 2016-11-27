# Class: winsw
#
#
class winsw::install (
  $install_drive        = $::winsw::params::install_drive,
  $install_path         = $::winsw::params::install_path,
  $service_name         = $::winsw::params::service_name,
  $winsw_binary_version = $::winsw::params::winsw_binary_version,
) inherits ::winsw::params {

  winsw::recursive_dir { 'install_directories':
    drive   => $install_drive,
    path    => $install_path,
    spliton => "/",
    before  => File['winsw_exe']
  }

  $install_full = "${install_drive}${install_path}${service_name}.exe"

  file { 'winsw_exe':
    ensure   => file,
    source   => "puppet:///modules/winsw/${winsw_binary_version}.exe",
    path     => "${install_full}"
  }
}