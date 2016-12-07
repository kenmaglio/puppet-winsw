# Defined Type install
#
#
define winsw::install (
  $ensure                  = present,
  $service_id              = $title,
  $service_name            = undef,
  $service_executable      = undef,
  $service_argument_string = undef,
  $winsw_binary_version    = 'winsw_1_19_1',
  $install_path            = 'C:/Program Files/WinSW/',
  $service_description     = 'WinSW for Puppet',
  $service_env_variables   = undef,
  $service_logmode         = 'rotate',
  $service_user            = undef,
  $service_pass            = undef,
  $service_domain          = undef,
  $service_interactive     = false,
) {

  if (!$service_id) {
    fail('Service ID must be provided')
  }
  if (!$service_name and $ensure == present) {
    fail('Service Name must be provided if ensure present')
  }
  if (!$service_executable and $ensure == present) {
    fail('Service Executable must be provided if ensure present')
  }
  if (!$service_argument_string and $ensure == present) {
    fail('Service Arguments must be provided - even if they are empty - if ensure present')
  }

  # ordering logic below is complex and I want to document the flow here
  # On Ensure:
  #   Initial install, we will be placing the files down on the server
  #   after those files exist, we need to notify the service to be installed

  #   On Changes to the config, we will have to stop, uninstall, install, and start the service
  #   The config file calls the rebuild exec (refreshonly) on initial install 
  #   because no file to some file - fires the notify. Unintended side effect - but causes no issues.

  #   If for some reason the service is uninstalled without a config file change, the logic
  #   will fire off the Install exec as a normal ensure as it is NOT a refreshonly

  # manage files
  # ensure entire path exists -- never remove
  if ($ensure == present) {
    toolbox::mkdirs { "directories_${service_id}":
      path   => $install_path,
    }
  }

  # reason for this bit of logic is on ensure absent we cannot
  # have the notify to try to install the service, effectively skipping the notify
  if ($ensure == present) {
    $notify_install = [ Exec["install_${service_id}"] ]
  } else {
    $notify_install = []
  }

  # place the exe file for winsw - named as the user wants.
  file { "winsw_exe_config_${service_id}":
    ensure => $ensure,
    source => 'puppet:///modules/winsw/exe.config',
    path   => "${install_path}${service_id}.exe.config",
  } ->
  file { "winsw_exe_${service_id}":
    ensure => $ensure,
    source => "puppet:///modules/winsw/${winsw_binary_version}.exe",
    path   => "${install_path}${service_id}.exe",
    notify => $notify_install,
  }

  # reason for this bit of logic is on ensure absent we cannot
  # have the notify to try to rebuild the service, effectively skipping the notify
  if ($ensure == present) {
    $notify_config_change = [ Exec["rebuild_service_${service_id}"] ]
  } else {
    $notify_config_change = []
  }

  # place the config file with the same name as the service - required for winsw
  file { "config_xml_${service_id}":
    ensure  => $ensure,
    content => epp('winsw/config.xml.epp',{
                  'service_id'              => $service_id,
                  'service_name'            => $service_name,
                  'service_executable'      => $service_executable,
                  'service_argument_string' => $service_argument_string,
                  'winsw_binary_version'    => $winsw_binary_version,
                  'install_path'            => $install_path,
                  'service_description'     => $service_description,
                  'service_env_variables'   => $service_env_variables,
                  'service_logmode'         => $service_logmode,
                  'service_user'            => $service_user,
                  'service_pass'            => $service_pass,
                  'service_domain'          => $service_domain,
                  'service_interactive'     => $service_interactive
                  }
                ),
    path    => "${install_path}${service_id}.xml",
    notify  => $notify_config_change,
  }

  if $ensure == present {
    # install the service
    exec { "install_${service_id}":
      command  => "& '${install_path}${service_id}.exe' install",
      unless   => "\$install = (& '${install_path}${service_id}.exe' status); \
                   if (\$install -eq \"NonExistent\") { exit 1 } else { exit 0 }",
      provider => powershell,
    }

    # only restart if we have installed first
    exec { "rebuild_service_${service_id}":
      command     => "& '${install_path}${service_id}.exe' stop;\
                      & '${install_path}${service_id}.exe' uninstall;\
                      & '${install_path}${service_id}.exe' install;\
                      & '${install_path}${service_id}.exe' start;",
      refreshonly => true,
      require     => Exec["install_${service_id}"],
      provider    => powershell,
    }
  }

  if $ensure == absent {
    # first stop and then uninstall the service
    exec { "stop_service_${service_id}":
      command  => "& '${install_path}${service_id}.exe' stop",
      unless   => "\$stop = (& '${install_path}${service_id}.exe' status); \
                   if (\$stop -eq \"Started\") { exit 1 } else { exit 0 }",
      provider => powershell,
      before   => [Exec["uninstall_${service_id}"],File["winsw_exe_${service_id}","config_xml_${service_id}"]],
    }

    exec { "uninstall_${service_id}":
      command  => "& '${install_path}${service_id}.exe' uninstall",
      unless   => "\$uninstall = (& '${install_path}${service_id}.exe' status); \
                   if (\$uninstall -eq \"Stopped\") { exit 1 } else { exit 0 }",
      provider => powershell,
      before   => File["winsw_exe_${service_id}","config_xml_${service_id}"],
    }
  }
}