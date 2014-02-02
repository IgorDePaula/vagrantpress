
stage{"first":
  before => Stage["main"],
}

node default{

  class{"prepare": stage => 'first', }

  notify{"Provision a wordpress server.": }

}


class prepare {
  if $::osfamily == 'Debian'{
    exec{"apt-get update":
      path => "/bin:/usr/bin",
    }
  }

  package{"librarian-puppet":
    ensure   => installed,
    provider => 'gem',
  }

  package{["git"]: ensure => installed,
    require => Exec["apt-get update"],
  }

  file{"/home/vagrant/.ssh": ensure => directory,}
  file{"/home/vagrant/.ssh/config":
    ensure => present,
    content => 'StrictHostKeyChecking no'
  }

  exec{"librarian-puppet update":
    path => "/bin:/usr/bin:/usr/local/bin",
    cwd  => "/vagrant/puppet",
    require => Package["librarian-puppet", "git"],
    environment => ["HOME=/home/vagrant"],
  }
}


#class { 'git::install': }
#class { 'subversion::install': }
#class { 'apache2::install': }
#class { 'php5::install': }
#class { 'mysql::install': }
#class { 'wordpress::install': }
#class { 'phpmyadmin::install': }
#class { 'phpqa::install': }
