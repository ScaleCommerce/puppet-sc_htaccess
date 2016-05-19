# == Class: sc_hataccess
#
# Simple class to generate and maintain htaccess and htpasswd files.
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*protected_dir*]
#   The directory which should be protected and where the .htaccess file will be placed.
#
# [*owner*]
#   Owner of files .htaccess and .htpasswd
#
# [*group*]
#   Group of files .htaccess and .htpasswd
#
# [*auth_name*]
#   Content of AuthName string in .htaccess file
#
# [*ensure*]
#   Ensure param for both files. Default is 'file', could be set to 'absent' to delete both files.
#
# === hiera Example
#
# classes:
#   - sc_htaccess
#
# sc_htaccess::protected_dir: /var/www/adminer.domain.com/web
# sc_htaccess::auth_name: 'domain Adminer'
# sc_htaccess::htpasswd_file_path: /var/www/adminer.domain.com
# sc_htaccess::htuser:
#   <USERNAME>: <ENCRYPTED PASSWORD>
#
# === Authors
#
# Andreas Ziethen ScaleCommerce GmbH <az@scale.sc>
#
# === Copyright
#
# Copyright 2016 ScaleCommerce GmbH
#
class sc_htaccess(
  $protected_dir,
  $owner                  = 'www-data',
  $group                  = 'www-data',
  $auth_name              = '',
  $htpasswd_file_path,
  $ensure                 = 'file',
) {

  $htpasswd_file     = "$htpasswd_file_path/.htpasswd"
  $htaccess_file     = "$protected_dir/.htaccess"
  $htaccess_tmp_file = "$protected_dir/.htaccess_tmp"
  $htuser            = hiera_hash('sc_htaccess::htuser', {})

  file { $htpasswd_file:
    path    => "$htpasswd_file_path/.htpasswd",
    owner   => $owner,
    group   => $group,
    ensure  => $ensure,
    content => template("${module_name}/htpasswd.erb"),
  }->

  file { $htaccess_tmp_file:
    path    => "$protected_dir/.htaccess_tmp",
    owner   => $owner,
    group   => $group,
    ensure  => $ensure,
    replace => false,
    content => template("${module_name}/htaccess.erb"),
  }->

  exec { 'move_htaccess_tmp_file':
    creates => $htaccess_file,
    command => "/bin/mv $htaccess_tmp_file $htaccess_file",
  }->

  file_line { 'replace_auth_user_file':
    ensure  => present,
    path    => $htaccess_file,
    match   => '^AuthUserFile',
    line    => "AuthUserFile '$htpasswd_file'",
  }





}
