#
# == Class: nagios::target
#
# This class must be included in every host that we want to monitor.
# It export nagios_host and nagios_service resources that are imported by
# nagios::monitor class. This resources implements basis check on the host.
#
# N.B: At this moment all nrpe checks defined here needs that nrpe check
# command string is pushed by nrpe class.

class nagios::target {

  Nagios_host {
    target => '/etc/nagios3/conf.d/nagios_hosts.cfg'
  }

  Nagios_service {
    target => "/etc/nagios3/conf.d/${::hostname}.cfg"
  }

  @@nagios_host { $::fqdn:
    ensure    =>  present,
    alias     =>  $::hostname,
    address   =>  $::clientcert,
    use       =>  'generic-host',
    host_name =>  $::hostname,
  }

  @@nagios_service { "check_ping_${::hostname}":
    check_command       =>  'check_ping!100.0,20%!500.0,60%',
    use                 =>  'generic-service',
    host_name           =>  $::hostname,
    notification_period =>  '24x7',
    service_description =>  "${::hostname}_check_ping",
  }

  @@nagios_service { "check_ssh_${::hostname}":
    check_command       =>  'check_ssh',
    use                 =>  'generic-service',
    host_name           =>  $::hostname,
    notification_period =>  '24x7',
    service_description =>  "${::hostname}_check_ssh",
    process_perf_data   =>  0,
  }

  #### Check nrpe - i file contenti i comandi da eseguire sono pushati dal modulo nrpe

  @@nagios_service { "check_nrpe_reachable_${::hostname}":
    check_command       =>  'check_nrpe_1arg!reachable',
    use                 =>  'generic-service',
    host_name           =>  $::hostname,
    notification_period =>  '24x7',
    service_description =>  "${::hostname}_check_nrpe_reachable",
  }

  @@nagios_service { "check_cpu_stats_${::hostname}":
    check_command       =>  'check_nrpe_1arg!check_cpu',
    use                 =>  'generic-service',
    host_name           =>  $::hostname,
    notification_period =>  '24x7',
    service_description =>  "${::hostname}_check_ping",
  }

  @@nagios_service { "check_load_${::hostname}":
    check_command       =>  'check_nrpe_1arg!check_load',
    use                 =>  'generic-service',
    host_name           =>  $::hostname,
    notification_period =>  '24x7',
    service_description =>  "${::hostname}_check_load",
  }

  @@nagios_service { "check_users_${::hostname}":
    check_command       =>  'check_nrpe_1arg!check_users',
    use                 =>  'generic-service',
    host_name           =>  $::hostname,
    notification_period =>  '24x7',
    service_description =>  "${::hostname}_check_users",
  }

  @@nagios_service { "check_disk_root_${::hostname}":
    check_command       =>  'check_nrpe_1arg!check_disk_root',
    use                 =>  'generic-service',
    host_name           =>  $::hostname,
    notification_period =>  '24x7',
    service_description =>  "${::hostname}_check_disk_root",
  }

  @@nagios_service { "check_disk_io_${::hostname}":
    check_command       =>  'check_nrpe_1arg!check_diskio',
    use                 =>  'generic-service',
    host_name           =>  $::hostname,
    notification_period =>  '24x7',
    service_description =>  "${::hostname}_check_diskio",
  }

  @@nagios_service { "check_meminfo_memfree_${::hostname}":
    check_command       =>  'check_nrpe_1arg!check_meminfo_memfree',
    use                 =>  'generic-service',
    host_name           =>  $::hostname,
    notification_period =>  '24x7',
    service_description =>  "${::hostname}_check_meminfo_memfree",
  }

  @@nagios_service { "check_meminfo_swapinuse_${::hostname}":
    check_command       =>  'check_nrpe_1arg!check_meminfo_swapinuse',
    use                 =>  'generic-service',
    host_name           =>  $::hostname,
    notification_period =>  '24x7',
    service_description =>  "${::hostname}_check_meminfo_swapinuse",
  }

  @@nagios_service { "check_total_procs_${::hostname}":
    check_command       =>  'check_nrpe_1arg!check_total_procs',
    use                 =>  'generic-service',
    host_name           =>  $::hostname,
    notification_period =>  '24x7',
    service_description =>  "${::hostname}_check_total_procs",
  }

  @@nagios_service { "check_zombie_procs_${::hostname}":
    check_command       =>  'check_nrpe_1arg!check_zombie_procs',
    use                 =>  'generic-service',
    host_name           =>  $::hostname,
    notification_period =>  '24x7',
    service_description =>  "${::hostname}_check_zombie_procs",
  }

  @@nagios_service { "check_ntp_client_${::hostname}":
    check_command       =>  'check_nrpe_1arg!check_ntp_client',
    use                 =>  'generic-service',
    host_name           =>  $::hostname,
    notification_period =>  '24x7',
    service_description =>  "${::hostname}_check_ntp_client",
  }

}
