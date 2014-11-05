# == Define: nagios::check
#
# Generic nagios check
#
# === Actions:
#
# - wrapper of nagios_service resource. This define eventualy push plugin and configuration file
#
# === Parameters:
#
# [*host*]
#  nagios_host where service should be monitored. Mandatory
#
# [*checkname*]
#  command name used by nagios to perform the check. if omitted used command will be check_<name>, where <name> is the resource name;
#
# [*plugin*]
#  if set to true it means that binary file called by nagios to make check is an external plugin not included in default nagios-plugin package
#
# [*plugin_source*]
#  If plugin is set to true this represent source of the plugin file. If omitted it will be: puppet:///modules/nagios/contrib/<checkname>
#
# [*plugin_config*]
#  if the nagios command_name to use this plugin is not already defined in nagios server set this to true and a configutation file will be pushed
#
# [*plugin_config_source*]
#  If plugin_config is set to true this represent source of the plugin config file to define nagios command_name. If omitted it will be puppet:///modules/nagios/contrib/<checkname>.cfg
#
# [*service_description*]
#  Nagios service_description of check. If omitted <checkname> will be used
#
# [*target*]
#  target file where nagios_check will be put. If omitted it will be ${nagios::nagiosconfdir}/<host>.cfg
#
# [*params*]
#  params passed to checkname in the form !ARG1!ARG2!ARG3. it must start with !
#
# [*service_template*]
#  template used by nagios check, default value is 'generic_service'
#
# [*notification_period*]
#  notification_period used by nagios
#
# [*notifications_enabled*]
#  0 disable notification, 1 otherwise. Default: 1
#
define nagios::check(
  $host,
  $ensure                 = present,
  $checkname              = false,
  $plugin                 = false,
  $plugin_source          = false,
  $plugin_config          = false,
  $plugin_config_source   = false,
  $service_description    = false,
  $target                 = false,
  $params                 = '',
  $service_template       = 'generic-service',
  $notification_period    = undef,
  $notifications_enabled  = undef,
  $freshness_threshold    = undef,
  $contact_groups         = undef,
)
{
  include nagios

  File {
    owner   => 'root',
    group   => 'admin',
    mode    => '0664',
  }

  # realcheckname is used only in template
  $realcheckname = $checkname ? {
    false   => "check_${name}",
    default => $checkname
  }

  $servicedescription= $service_description ? {
    false   => $realcheckname,
    default => $service_description,
  }

  $check_target = $target ? {
    false   => "${nagios::nagiosconfdir}/${host}.cfg",
    default => "${nagios::nagiosconfdir}/$target",
  }

  if $plugin {

    $pluginsource = $plugin_source ? {
      false   => "puppet:///modules/nagios/contrib/${realcheckname}",
      default => $plugin_source,
    }

    # The resource could be already defined by another instance of the
    # same check
    # ex: check_disk, check_proc can be used multiple times on the same host
    # with different parameters
    if ! defined(File["${nagios::pluginscontribdir}/${realcheckname}"]) {
      file { "${nagios::pluginscontribdir}/${realcheckname}":
        ensure  => $ensure,
        mode    => '0775',
        source  => $pluginsource,
      }
    }
  }

  if $plugin_config {
    $pluginconfigsource = $plugin_config_source? {
      false   => "puppet://modules/nagios/contrib/${realcheckname}.cfg",
      default => $plugin_config_source,
    }

    if !defined(File["${nagios::pluginconfigdir}/${realcheckname}.cfg"]) {
      file { "${nagios::pluginconfigdir}/${realcheckname}.cfg":
        ensure  => $ensure,
        mode    => '0775',
        source  => $pluginconfigsource,
      }
    }
  }

  nagios_service { "${servicedescription}-${host}":
    use                   => $service_template,
    target                => $check_target,
    host_name             => $host,
    service_description   => $servicedescription,
    check_command         => "${realcheckname}${params}",
    notification_period   => $notification_period,
    notifications_enabled => $notifications_enabled,
    freshness_threshold   => $freshness_threshold,
    contact_groups        => $contact_groups,
  }

  if !defined(File[$check_target]) {
    file { $check_target:
      mode    => '0644',
      require => Nagios_service["${servicedescription}-${host}"]
    }
  }
}
