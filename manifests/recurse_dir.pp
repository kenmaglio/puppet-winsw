define winsw::recurse_dir ($path, $spliton='/') {
  $folders = split($path, $spliton)
  $drive = $folders[0]
  $folders.each |$index, $folder| {
    if($index>0) {
      $calculated_folder = inline_template("<%= @folders[1, @index + 1].join('/') %>")
      $full_path = "${drive}/${calculated_folder}"
      if (! defined(File[$full_path]) and $full_path != $drive) {
        file { $full_path :
          ensure => directory,
        }
      }
    }
  }
}