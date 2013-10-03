#SL6 so 2.1
class lustre_server ( $version="2.1") {
  if ($version=="2.1") {


    file { '/etc/yum.repos.d/oxford-local-lustre-2.1-server.repo':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/lustre_server/oxford-local-lustre-2.1-server.repo', 
    
    }
  }
  $packages = [ "*686" , "*386" ]
  package { $packages : ensure => absent }

  package { [ "e2fsprogs" , "lustre", "lustre-modules" , "kernel", "libss",  "lustre-ldiskfs", "perf", "kernel-firmware",  "e2fsprogs-libs" ] :  #libcomm_err
		ensure =>installed,
		require => File['/etc/yum.repos.d/oxford-local-lustre-2.1-server.repo'] 
          }


}



