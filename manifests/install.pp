define winsw::install (
  $winsw_binary_version = 'winsw_1_19_1',
  $install_path = 'C:/Program Files/WinSW/',
  $winsw_exe_name,
  $service_id,
  $service_name,
  $service_description = 'An executable is being run as a service using WinSW',
  $service_env_variables = undef,
  $service_executable,
  $service_argument_string = '',
  $service_logmode = 'rotate',
) {

  # ensure entire path exists
  winsw::recurse_dir { 'install_directories':
    path    => $install_path,
    before  => File['winsw_exe','config_xml']
  }

  # place the exe file for winsw - named as the user wants.
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