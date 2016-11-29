# Defined Type Install
#
#
define winsw::install (
  $service_id              = undef,
  $ensure                  = present,
  $winsw_binary_version    = 'winsw_1_19_1',
  $install_path            = 'C:/Program Files/WinSW/',
) {

  if (!$service_id) {
    fail('Service ID must be provided')
  }

  if $ensure == present {
    # install the service
    exec { "install_${service_id}":
      command  => "& '${install_path}${service_id}.exe' install",
      unless   => "\$install = (& '${install_path}${service_id}.exe' status); " \
                  "if (\$install -eq \"NonExistent\") { exit 1 } else { exit 0 }",
      provider => powershell,
    }
  }

  if $ensure == absent {
    # first stop and uninstall the service
    exec { "stop_service_${service_id}":
      command  => "& '${install_path}${service_id}.exe' stop",
      unless   => "\$stop = (& '${install_path}${service_id}.exe' status); " \
                  "if (\$stop -eq \"Started\") { exit 1 } else { exit 0 }",
      provider => powershell,
    } ->

    exec { "uninstall_${service_id}":
      command  => "& '${install_path}${service_id}.exe' uninstall",
      unless   => "\$uninstall = (& '${install_path}${service_id}.exe' status); " \
                  "if (\$uninstall -eq \"Stopped\") { exit 1 } else { exit 0 }",
      provider => powershell,
    }
  }

}