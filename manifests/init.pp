class lustre_server ( $majorversion=$lustre_server::params::majorversion,
                      $minorversion=$lustre_server::params::minorversion,
		      $kkernelversion=$lustre_server::params::kkernelversion,
                      $lkernelversion=$lustre_server::params::lkernelversion 
  ) inherits lustre_server::params {
  notify {"Setting up lustre server with lustreversion $majorversion" : }
  #Paranoia
  if ($majorversion=="2.1") {


    file { "/etc/yum.repos.d/oxford-local-lustre-${majorversion}-server.repo":
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    source  => "puppet:///modules/lustre_server/oxford-local-lustre-${majorversion}-server.repo", 
    
    }
  }
  if ($majorversion=="2.5") {
    file { "/etc/yum.repos.d/oxford-local-lustre-${majorversion}-server.repo":
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    source  => "puppet:///modules/lustre_server/oxford-local-lustre-${majorversion}-server.repo", 
    
    }
  }
  $packages = [ "*686" , "*386" ]
  package { $packages : ensure => absent }
  #The name scheme is slightly different for kernel and lustre packages (- -->_)

  $pinnedkpackages = [ "kernel-${kkernelversion}", "kernel-firmware-${kkernelversion}",]
  $pinnedlkpackages = [ "lustre", "lustre-modules", ]
  $pinnedkopackages = [ "perf", ]

  package { $pinnedkpackages : 
            ensure => "installed",
	    require => File["/etc/yum.repos.d/oxford-local-lustre-${majorversion}-server.repo"] ,
          }

  package { $pinnedlkpackages :
            ensure => "${majorversion}.${minorversion}-${lkernelversion}",
            require => [Package[$pinnedkpackages], File["/etc/yum.repos.d/oxford-local-lustre-${majorversion}-server.repo"] ]
          }

  package { $pinnedkopackages :
            ensure => "${kkernelversion}",
            require => File["/etc/yum.repos.d/oxford-local-lustre-${majorversion}-server.repo"],
  }

  package { [ "e2fsprogs" ,  "libss", "e2fsprogs-libs" ] :  #libcomm_err
		ensure =>installed,
		require => File["/etc/yum.repos.d/oxford-local-lustre-${majorversion}-server.repo"] 
          }

   
}



