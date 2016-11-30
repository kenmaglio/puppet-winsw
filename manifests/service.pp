# Service Defined Type
#
#
define winsw::service (
  $service_id   = undef,
  $ensure       = undef,
  $install_path = 'C:/Program Files/WinSW/',
) {

  if (!$service_id) {
    fail('Service ID must be provided')
  }
  if (!$ensure) {
    fail('Ensure must be provided')
  }

  service { $service_id:
    ensure  => $ensure,
    start   => "${install_path}${service_id}.exe' start",
    stop    => "${install_path}${service_id}.exe' stop",
    restart => "${install_path}${service_id}.exe' restart!",
    status  => "${install_path}${service_id}.exe' status",
  }

}
