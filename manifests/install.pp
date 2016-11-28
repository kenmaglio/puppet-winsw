define winsw::install (
  $winsw_binary_version = 'winsw_1_19_1',
  $install_path = 'C:/Program Files/WinSW/',
  $service_id,
  $service_name,
  $service_description = 'An executable is being run as a service using WinSW',
  $service_env_variables = undef,
  $service_executable,
  $service_argument_string = '',
  $service_logmode = 'rotate',
) {

  # ensure entire path exists
  winsw::recurse_dir { "install_directories_${service_id}":
    path    => $install_path,
    before  => File["winsw_exe_${service_id}","config_xml_${service_id}"]
  }

  # place the exe file for winsw - named as the user wants.
  file { "winsw_exe_${service_id}":
    ensure   => file,
    source   => "puppet:///modules/winsw/${winsw_binary_version}.exe",
    path     => "${install_path}${service_id}.exe",
    before   => File["config_xml_${service_id}"],
    notify   => Exec["uninstall_service_${service_id}"]
  }

  file { "config_xml_${service_id}":
    ensure   => file,
    content  => epp('winsw/config.xml.epp'),
    path     => "${install_path}${service_id}.xml",
    notify   => Exec["uninstall_service_${service_id}"]
  }

  exec { "uninstall_service_${service_id}":
    command  => "& '${install_path}${service_id}.exe' uninstall",
    unless   => "\$result = (& '${install_path}${service_id}.exe' status); if (\$result -eq \"NonExistent\") { exit 1 } else { exit 0 }",
    provider => powershell,
    notify   => Exec["install_service_${service_id}"]
  }

  exec { "install_service_${service_id}":
    command  => "& '${install_path}${service_id}.exe' install",
    unless   => "\$result = (& '${install_path}${service_id}.exe' status); if (\$result -eq \"NonExistent\") { exit 1 } else { exit 0 }",
    provider => powershell
  }

}