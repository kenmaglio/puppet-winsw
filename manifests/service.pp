# Service Defined Type
#
#
define winsw::service (
  $service_id = $title,
  $ensure = undef,
  $install_path = 'C:/Program Files/WinSW/',
) {

  if (!$service_id) {
    fail('Service ID must be provided')
  }
  if (!$ensure) {
    fail('Ensure must be provided')
  }

  if ($ensure == running ) {
    exec { "start_service_${service_id}":
      command  => "& '${install_path}${service_id}.exe' start",
      unless   => "\$started = (& '${install_path}${service_id}.exe' status); \
                   if (\$started -eq \"Started\") { exit 0 } else { exit 1 }",
      provider => powershell,
    }
  }

  if ($ensure == stopped ) {
    exec { "stop_service_${service_id}":
      command     => "& '${install_path}${service_id}.exe' stop",
      unless      => "\$started = (& '${install_path}${service_id}.exe' status); \
                      if (\$installed -eq \"Stopped\") { exit 0 } else { exit 1 }",
      refreshonly => true,
      provider    => powershell,
    }
  }

}