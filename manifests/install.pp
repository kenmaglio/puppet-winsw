# Class: winsw
#
#
class winsw::install (
  $winsw_binary_version    = $::winsw::params::winsw_binary_version,
  $install_path            = $::winsw::params::install_path,
  $winsw_exe_name          = $::winsw::params::winsw_exe_name,
  $service_id              = $::winsw::params::service_id,
  $service_name            = $::winsw::params::service_name,
  $service_description     = $::winsw::params::service_description,
  $service_env_variables   = $::winsw::params::service_env_variables,
  $service_executable      = $::winsw::params::service_executable,
  $service_argument_string = $::winsw::params::service_argument_string,
  $service_logmode         = $::winsw::params::service_logmode,
) inherits ::winsw::params {

  winsw::recurse_dir { 'install_directories':
    path    => $install_path,
    before  => File['winsw_exe','config_xml']
  }

  file { 'winsw_exe':
    ensure   => file,
    source   => "puppet:///modules/winsw/${winsw_binary_version}.exe",
    path     => "${install_path}${winsw_exe_name}.exe",
    before   => File['config_xml'],
    notify   => Exec['uninstall_service']
  }

  file { 'config_xml':
    ensure   => file,
    content  => epp('winsw/config.xml.epp'),
    path     => "${install_path}${winsw_exe_name}.xml",
    notify   => Exec['uninstall_service']
  }

  exec { 'uninstall_service':
    command  => "& '${install_path}${winsw_exe_name}.exe' uninstall",
    unless   => "\$result = (& '${install_path}${winsw_exe_name}.exe' status); if (\$result -eq \"NonExistent\") { exit 1 } else { exit 0 }",
    provider => powershell,
    notify   => Exec['install_service']
  }

  exec { 'install_service':
    command  => "& '${install_path}${winsw_exe_name}.exe' install",
    unless   => "\$result = (& '${install_path}${winsw_exe_name}.exe' status); if (\$result -eq \"NonExistent\") { exit 1 } else { exit 0 }",
    provider => powershell
  }

}