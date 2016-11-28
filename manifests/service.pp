define winsw::service (
  $ensure = 'running',
  $install_path = 'C:/Program Files/WinSW/',
  $winsw_exe_name,
) {

  exec { 'install_service':
    command  => "& '${install_path}${winsw_exe_name}.exe' start",
    unless   => "\$result = (& '${install_path}${winsw_exe_name}.exe' status); if (\$result -eq \"Running\") { exit 1 } else { exit 0 }",
    provider => powershell
  }
}