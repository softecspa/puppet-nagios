# == Class: nagios::monitor
#
# This class configure nagios hosts and services exported by nagios::target class.
# Packages needed are installed and exported resources are collected. Only inclusion in nagios server host is needed
#
# === Examples
#
# to disable monitoring on a entire host add
#
# Nagios_host <<| host_name == 'hostname' |>> { ensure  =>  absent,}
# Nagios_service <<| host_name == 'hostname' |>> { ensure  =>  absent,}
#
# or, for a single service
# Nagios_service <<| title == 'checkname_hostname' |>> { ensure  =>  absent,}
class nagios::monitor {

  package { [ 'nagios3', 'nagios-plugins', 'nagios-nrpe-plugin']:
    ensure  =>  installed,
  }

  service { 'nagios3':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => [
      Package['nagios3'],
      Package['nagios-plugins']
    ],
    require   => [
      File['/etc/nagios3/conf.d/'],
      File['/etc/nagios-plugins/config']
    ]
  }

  file { '/etc/nagios3/conf.d/':
    owner   => 'nagios',
    group   => 'nagios',
    recurse => true
  }

  file {'/etc/nagios-plugins/config':
    owner   => 'nagios',
    group   => 'nagios',
    recurse => true
  }

  #Per disabilitare il monitoraggio di un host

  #Nagios_host <<| host_name == 'liliana-master' |>> { ensure  =>  absent,}
  #Nagios_service <<| host_name == 'liliana-master' |>> { ensure  =>  absent,}


  Nagios_host <<||>> {
    notify  => Service['nagios3'],
    require => Package['nagios3'],
  }

  Nagios_service  <<||>> {
    notify  => Service['nagios3'],
    require => Package['nagios3'],
  }

}
