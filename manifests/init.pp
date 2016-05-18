# == Class: sc_hataccess
#
# Full description of class dummy here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'dummy':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
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
  $owner          = 'www-data',
  $group          = 'www-data',
  $auth_name      = '',
  $htpasswd_file_path,
  $ensure         = 'file',
) {

  $htpasswd_file = "$htpasswd_file_path/.htpasswd"
  $htaccess_file = "$protected_dir/.htaccess"
  $htuser        = hiera_hash('sc_htaccess::htuser', {})

  file { $htpasswd_file:
    path => "$htpasswd_file_path/.htpasswd",
    owner => $owner,
    group => $group,
    ensure => $ensure,
    content => template("${module_name}/htpasswd.erb"),
  }->

  file { $htaccess_file:
    path => "$protected_dir/.htaccess",
    owner => $owner,
    group => $group,
    ensure => $ensure,
    content => template("${module_name}/htaccess.erb"),
  }

}
