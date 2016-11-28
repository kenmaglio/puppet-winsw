# Class: Params
#
#
class winsw::params {
  $winsw_binary_version    = 'winsw_1_19_1'
  $install_path            = 'C:/Program Files/WinSW/'
  $winsw_exe_name          = 'my_service'
  $service_id              = 'MyService'
  $service_name            = 'My Service'
  $service_description     = 'This service runs My Service'
  $service_env_variables   = undef
  $service_executable      = 'powershell'
  $service_argument_string = ''
  $service_logmode         = 'rotate'
}