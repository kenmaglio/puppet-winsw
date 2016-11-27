# Class: winsw
#
#
class winsw (
  $install_drive        = $::winsw::params::install_drive,
  $install_path         = $::winsw::params::install_path,
  $service_name         = $::winsw::params::service_name,
  $winsw_binary_version = $::winsw::params::winsw_binary_version,
) inherits ::winsw::params {

}