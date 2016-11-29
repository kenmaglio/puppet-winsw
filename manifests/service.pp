# Service Defined Type
#
#
define winsw::service (
  $service_id = undef,
  $ensure = running,
  $install_path = 'C:/Program Files/WinSW/',
) {

  if (!$service_id) {
    fail('Service ID must be provided')
  }

  exec { "run_service_${service_id}":
    command  => "& '${install_path}${service_id}.exe' start",
    unless   => "\$started = (& '${install_path}${service_id}.exe' status); " \
                "if (\$started -eq \"Started\") { exit 0 } else { exit 1 }",
    provider => powershell
  }

}