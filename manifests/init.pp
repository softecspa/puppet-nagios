class nagios
{
  $nagiosbasedir          = '/etc/nagios3'
  $nagiosconfdir          = "${nagiosbasedir}/conf_imported.d"
  $nagiosplugins          = '/usr/lib/nagios/plugins'
  $pluginscontribdir      = "${nagiosplugins}/contrib"
  $pluginconfigdir        = '/etc/nagios-plugins/config'
}
