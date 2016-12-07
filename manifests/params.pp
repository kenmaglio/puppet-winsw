# Class: Params
#
#
class winsw::params {
  $winsw_binary_version    = 'winsw_1_19_1'
  $install_path            = 'C:/Program Files/WinSW/'
  $service_name            = 'My Service'
  $service_description     = 'WinSW Service Wrapper'
  $service_env_variables   = undef
  $service_executable      = 'powershell'
  $service_argument_string = ''
  $service_logmode         = 'rotate'
  $service_user            = undef
  $service_pass            = undef
  $service_domain          = undef
  $service_interactive     = false
}