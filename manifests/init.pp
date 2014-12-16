class tse_websphere (
  $installables_root = '/opt/wlp_files',
  $websphere_version = '8.5.5.4',
  $demo_server = $::servername,
) {
  include java
  include profile::firewall

  File {
    before => Class['::wlp'],
  }

  File_remote {
    before  => Class['::wlp'],
    require => File["${installables_root}/installables"],
  }
  notify { "server: ${demo_server}": }

  file {'/opt/wlp':
    ensure => directory,
  }

  file { $installables_root:
    ensure => directory,
  }
  
  file { "${installables_root}/installables":
    ensure => directory,
  }

  file { "/opt/wlp/jenkins.xml":
    ensure => present,
    source => 'puppet:///modules/tse_websphere/jenkins.xml',
  }

  remote_file { '/opt/wlp/jenkins.war':
    ensure => latest,
    source => "http://${demo_server}/war/latest/jenkins.war",
  }

  remote_file { "${installables_root}/installables/wlp-base-trial-runtime-${websphere_version}.jar":
    ensure => latest,
    source => "http://${demo_server}/wlp/wlp-base-trial-runtime-${websphere_version}.jar",
  }

  remote_file { "${installables_root}/installables/wlp-trial-extended-${websphere_version}.jar":
    ensure => latest,
    source => "http://${demo_server}/wlp/wlp-trial-extended-${websphere_version}.jar",
  }

  remote_file { "${installables_root}/installables/wlp-trial-extras-${websphere_version}.jar":
    ensure => latest,
    source => "http://${demo_server}/wlp/wlp-trial-extras-${websphere_version}.jar",
  }


  firewall { '100 allow connections to websphere':
    proto   => 'tcp',
    dport   => '9080',
    action  => 'accept',
  }

  class { "::wlp":
     appNames                   => ['jenkins.war',],
     applicationSourceDirectory => "/opt/wlp",
     serverBinaryName           => "wlp-base-trial-runtime-${websphere_version}.jar",
     extendedBinaryName         => "wlp-trial-extended-${websphere_version}.jar",
     extrasBinaryName           => "wlp-trial-extras-${websphere_version}",
     standalone                 => true,
     acceptLicense              => true,
     puppetFileRoot             => $installables_root,
     require                    => Class['java']
  }
}
