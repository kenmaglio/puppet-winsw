# Service Defined Type
#
#
define winsw::service (
  $service_id,
  $ensure = running,
  $install_path = 'C:/Program Files/WinSW/',
) {

  exec { "run_service_${service_id}":
    command  => "& '${install_path}${service_id}.exe' start",
    unless   => "\$started = (& '${install_path}${service_id}.exe' status); if (\$started -eq \"Started\") { exit 0 } else { exit 1 }",
    provider => powershell
  }

}