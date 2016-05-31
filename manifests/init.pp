class lustre_server ( $majorversion=$lustre_server::params::majorversion,
                      $minorversion=$lustre_server::params::minorversion,
		      $kkernelversion=$lustre_server::params::kkernelversion,
                      $lkernelversion=$lustre_server::params::lkernelversion,
                      $fkernelversion=$lustre_server::params::fkernelversion,
                      $kernelsuffix=$lustre_server::params::kernelsuffix,
                      $repo=$lustre_server::params::repo, 
  ) inherits lustre_server::params {
  notify {"Setting up lustre server with lustreversion $majorversion" : }

  if ( "${repo}" == "default" ) {
    $reposource="puppet:///modules/lustre_server/oxford-local-lustre-${majorversion}-server.repo" 
  
  } 
  else {
    $reposource=$repo
  }
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
    source  => "${reposource}", 
    }
  }
  if ($majorversion=="testing") {
    file { "/etc/yum.repos.d/oxford-local-lustre-${majorversion}-server.repo":
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    source  => "${reposource}",
    }

  }
  file { "/usr/local/bin/lustre_bootstrap":
    ensure  => present,
    mode    => '0744',
    owner   => 'root',
    group   => 'root',
    content => template("$module_name/lustre_bootstrap.erb")
  }

  $packages = [ "*686" , "*386" ]
  package { $packages : ensure => absent }
  #The name scheme is slightly different for kernel and lustre packages (- -->_)

  $pinnedkpackages = [ "kernel", ]
  $pinnedkfpackages = [  "kernel-firmware",]
  $pinnedlkpackages = [ "lustre", "lustre-modules", ]
  $pinnedkopackages = [ "perf", ]

  package { $pinnedkpackages : 
            ensure => "${kkernelversion}${kernelsuffix}",
	    require => File["/etc/yum.repos.d/oxford-local-lustre-${majorversion}-server.repo"] ,
          }

  package { $pinnedkfpackages : 
            ensure => "${fkernelversion}",
	    require => File["/etc/yum.repos.d/oxford-local-lustre-${majorversion}-server.repo"] ,
          }
  package { $pinnedlkpackages :
            ensure => "${majorversion}.${minorversion}-${lkernelversion}",
            require => [Package[$pinnedkpackages], File["/etc/yum.repos.d/oxford-local-lustre-${majorversion}-server.repo"] ]
          }

  package { $pinnedkopackages :
            ensure => "${fkernelversion}",
            require => File["/etc/yum.repos.d/oxford-local-lustre-${majorversion}-server.repo"],
  }

  package { [ "e2fsprogs" ,  "libss", "e2fsprogs-libs" ] :  #libcomm_err
		ensure =>installed,
		require => File["/etc/yum.repos.d/oxford-local-lustre-${majorversion}-server.repo"] 
          }

   
}



