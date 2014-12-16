class tse_websphere (
  $installables_root = '/opt/wlp_files',
  $websphere_version = '8.5.5.4',
) {
  include java
 
  file {'/opt/wlp':
    ensure => directory,
    before => Class['::wlp'],
  }

  file { $installables_root:
    ensure => directory,
    before => Class['::wlp'],
  }

  remote_file { '/opt/wlp/jenkins.war':
    ensure => latest,
    source => 'http://master.inf.puppetlabs.demo/war/latest/jenkins.war',
    before => Class['::wlp'],
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
