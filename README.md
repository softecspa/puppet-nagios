puppet-nagios
=============

install of nagios, export and import hosts and cheks definition. 

==

modulo molto spartano ed incompleto per la gestione dell'installazione di nagios e dell'esportazione dei check.

 * nagios::target esporta i check di base e la definizione dell'host relativi all'host sul quale viene incluso
 * nagios::monitor installa i packages necessari per nagios ed importa hosts e checks precedentemente esportati dai nodi monitorati

