# Class: winsw
#
#
class winsw {
  $install_drive = $::winsw::params::install_drive,
  $install_path = $::winsw::params::install_path,
  $service_name = $::winsw::params::service_name,
} inherits ::winsw::params {
  winsw::recursive_dir {
    drive   => $install_drive,
    path    => $install_path,
    spliton => "/",
    before => File['winsw_exe'] ];
  }

  $install_full = "${install_drive}${install_path}${service_name}.exe"
  file { 'winsw_exe':
    ensure => file,
    source => 'puppet:///modules/winsw/binaries/winsw-1.19.1-bin.exe',
    path   => $install_full;
  }
}