class profile::wlp (
) {
  include java
  include wget
  file {'/opt/wlp':
    ensure => directory,
  }->
  wget::fetch { "jenkins war file":
    source => 'http://master.inf.puppetlabs.demo/war/latest/jenkins.war',
    destination => '/opt/wlp/jenkins.war',
  }->
  firewall { '100 allow connections to websphere':
    proto   => 'tcp',
    dport   => '9080',
    action  => 'accept',
  }->
  class { "::wlp":
     appNames => ['jenkins.war',],
     applicationSourceDirectory => "/opt/wlp",
     serverBinaryName => "wlp-base-trial-runtime-8.5.5.4.jar",
     extendedBinaryName => "wlp-trial-extended-8.5.5.4.jar",
     extrasBinaryName => "wlp-trial-extras-8.5.5.4",
     standalone => true,
     acceptLicense => true,
     puppetFileRoot => '/vagrant',
     require => Class['java']
  }
}
