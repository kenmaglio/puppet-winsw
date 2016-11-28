define winsw::install (
  $ensure                  = undef,
  $winsw_binary_version    = 'winsw_1_19_1',
  $install_path            = 'C:/Program Files/WinSW/',
  $service_id              = undef,
  $service_name            = undef,
  $service_description     = 'An executable is being run as a service using WinSW',
  $service_env_variables   = undef,
  $service_executable      = undef,
  $service_argument_string = '',
  $service_logmode         = 'rotate',
) {

  if $ensure == present {
    # ensure entire path exists
    winsw::recurse_dir { "add_directories_${service_id}":
      ensure  => directory,
      path    => $install_path,
      before  => File["add_winsw_exe_${service_id}","add_config_xml_${service_id}"]
    }

    # place the exe file for winsw - named as the user wants.
    file { "add_winsw_exe_${service_id}":
      ensure   => file,
      source   => "puppet:///modules/winsw/${winsw_binary_version}.exe",
      path     => "${install_path}${service_id}.exe",
      before   => File["config_xml_${service_id}"],
      notify   => Exec["uninstall_service_${service_id}"]
    }

    # place the config file with the same name as the service - required for winsw
    file { "add_config_xml_${service_id}":
      ensure   => file,
      content  => epp('winsw/config.xml.epp'),
      path     => "${install_path}${service_id}.xml",
      notify   => Exec["uninstall_service_${service_id}"]
    }

    # ensure we have stopped and uninstalled the service, this is to accept changes to config.
    exec { "uninstall_service_${service_id}":
      command  => "& '${install_path}${service_id}.exe' uninstall",
      unless   => "\$result = (& '${install_path}${service_id}.exe' status); if (\$result -eq \"NonExistent\") { exit 1 } else { exit 0 }",
      provider => powershell,
      notify   => Exec["install_service_${service_id}"]
    }

    # install the service after any changes or on initial install
    exec { "install_service_${service_id}":
      command  => "& '${install_path}${service_id}.exe' install",
      unless   => "\$result = (& '${install_path}${service_id}.exe' status); if (\$result -eq \"NonExistent\") { exit 1 } else { exit 0 }",
      provider => powershell
    }
  }

  if $ensure == absent {
    # first stop and uninstall the service
    exec { "stop_service_${service_id}":
      command  => "& '${install_path}${service_id}.exe' stop",
      unless   => "\$result = (& '${install_path}${service_id}.exe' status); if (\$result -eq \"Stopped\") { exit 1 } else { exit 0 }",
      provider => powershell,
      notify   => Exec["remove_service_${service_id}"]
    }

    exec { "remove_service_${service_id}":
      command  => "& '${install_path}${service_id}.exe' uninstall",
      unless   => "\$result = (& '${install_path}${service_id}.exe' status); if (\$result -eq \"NonExistent\") { exit 1 } else { exit 0 }",
      provider => powershell,
      notify   => File["remove_config_xml_${service_id}"]
    }

    # now remove Files
    file { "remove_config_xml_${service_id}":
      ensure   => absent,
      content  => epp('winsw/config.xml.epp'),
      path     => "${install_path}${service_id}.xml",
      notify   => File["remove_winsw_exe_${service_id}"]
    }

    file { "remove_winsw_exe_${service_id}":
      ensure   => absent,
      source   => "puppet:///modules/winsw/${winsw_binary_version}.exe",
      path     => "${install_path}${service_id}.exe",
    }

  }

}