# Files Defined Type
#
#
define winsw::files (
  $service_id              = undef,
  $service_name            = undef,
  $service_executable      = undef,
  $service_argument_string = undef,
  $ensure                  = present,
  $winsw_binary_version    = 'winsw_1_19_1',
  $install_path            = 'C:/Program Files/WinSW/',
  $service_description     = 'WinSW for Puppet',
  $service_env_variables   = undef,
  $service_logmode         = 'rotate',
) {

  if (!$service_id) {
    fail('Service ID must be provided')
  }
  if (!$service_name) {
    fail('Service Name must be provided')
  }
  if (!$service_executable) {
    fail('Service Executable must be provided')
  }
  if (!$service_argument_string) {
    fail('Service Arguments must be provided - even if they are empty')
  }

  # ensure entire path exists -- never remove
  if ($ensure == present) {
    winsw::recurse_dir { "directories_${service_id}":
      ensure => directory,
      path   => $install_path,
    }
  }

  # place the exe file for winsw - named as the user wants.
  file { "winsw_exe_${service_id}":
    ensure => $ensure,
    source => "puppet:///modules/winsw/${winsw_binary_version}.exe",
    path   => "${install_path}${service_id}.exe",
  }

  # place the config file with the same name as the service - required for winsw
  file { "config_xml_${service_id}":
    ensure  => $ensure,
    content => epp('winsw/config.xml.epp'),
    path    => "${install_path}${service_id}.xml",
  }

  file { "${install_path}${service_id}.err.log":
    ensure => $ensure
  }

  file { "${install_path}${service_id}.out.log":
    ensure => $ensure
  }

  file { "${install_path}${service_id}.wrapper.log":
    ensure => $ensure
  }
}