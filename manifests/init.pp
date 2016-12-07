# Class: winsw
#
#
class winsw (
  $winsw_binary_version    = $::winsw::params::winsw_binary_version,
  $install_path            = $::winsw::params::install_path,
  $service_id              = $::winsw::params::service_id,
  $service_name            = $::winsw::params::service_name,
  $service_description     = $::winsw::params::service_description,
  $service_env_variables   = $::winsw::params::service_env_variables,
  $service_executable      = $::winsw::params::service_executable,
  $service_argument_string = $::winsw::params::service_argument_string,
  $service_logmode         = $::winsw::params::service_logmode,
  $service_user            = $::winsw::params::service_user,
  $service_pass            = $::winsw::params::service_pass,
  $service_domain          = $::winsw::params::service_domain,
  $service_interactive     = $::winsw::params::service_interactive,
) inherits ::winsw::params {

  winsw::install { 'install_myservice':
    ensure                  => present,
    winsw_binary_version    => $winsw_binary_version,
    install_path            => $install_path,
    service_id              => $service_id,
    service_name            => $service_name,
    service_executable      => $service_executable,
    service_argument_string => $service_argument_string,
    service_description     => $service_description,
    service_env_variables   => $service_env_variables,
    service_logmode         => $service_logmode,
    service_user            => $service_user,
    service_pass            => $service_pass,
    service_domain          => $service_domain,
  } ->

  winsw::service { 'run_myservice':
    ensure     => running,
    service_id => $service_id,
  }

}