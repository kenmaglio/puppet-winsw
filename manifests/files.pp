define winsw::files (
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


  # ensure entire path exists -- never remove
  if $ensure == present {
    winsw::recurse_dir { "directories_${service_id}":
      ensure  => directory,
      path    => $install_path,
    }
  }

  # place the exe file for winsw - named as the user wants.
  file { "winsw_exe_${service_id}":
    ensure   => $ensure,
    source   => "puppet:///modules/winsw/${winsw_binary_version}.exe",
    path     => "${install_path}${service_id}.exe",
  } 

  # place the config file with the same name as the service - required for winsw
  file { "config_xml_${service_id}":
    ensure   => $ensure,
    content  => epp('winsw/config.xml.epp'),
    path     => "${install_path}${service_id}.xml",
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