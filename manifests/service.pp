# Service Defined Type
#
#
define winsw::service (
  $service_id = undef,
  $ensure = undef,
  $install_path = 'C:/Program Files/WinSW/',
) {

  if (!$service_id) {
    fail('Service ID must be provided')
  }
  if (!$ensure) {
    fail('Ensure must be provided')
  }

  exec { "start_service_${service_id}":
    command  => "& '${install_path}${service_id}.exe' start",
    unless   => "\$started = (& '${install_path}${service_id}.exe' status); " \
                "if (\$started -eq \"Started\") { exit 0 } else { exit 1 }",
    provider => powershell,
  }

  exec { "stop_service_${service_id}":
    command     => "& '${install_path}${service_id}.exe' stop",
    unless      => "\$started = (& '${install_path}${service_id}.exe' status); " \
                   "if (\$installed -eq \"NonExistent\") { exit 0 } else { exit 1 }",
    refreshonly => true,
    provider    => powershell,
  }

  exec { "restart_service_${service_id}":
    command     => "& '${install_path}${service_id}.exe' restart",
    refreshonly => true,
    provider    => powershell,
  }

}