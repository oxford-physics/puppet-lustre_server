class lustre_server::params (
    $majorversion  = hiera("lustre_server::params::majorversion","2.1") ,
    $minorversion  = hiera("lustre_server::params::minorversion","6") ,
    $kkernelversion= hiera("lustre_server::params::kkernelversion","2.6.32-358.11.1.el6_lustre") ,
    $lkernelversion= hiera("lustre_server::params::lkernelversion","2.6.32_358.11.1.el6_lustre.x86_64") ,
    $mdt          =  hiera("lustre_server::params::mdt",false) , 
    $repo         =  hiera("lustre_server::params::repo","default")  ,
)
{   
}
