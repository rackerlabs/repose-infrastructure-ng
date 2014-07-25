# see https://forge.puppetlabs.com/maestrodev/maven for many examples
# including how to set up ~/.m2/settings.xml
class{ "maven::maven":
  version => "3.2.1",
}

# see https://forge.puppetlabs.com/puppetlabs/java
include java
#class{ "java":
#  distribution => "jdk",
#  version      => "present",
#)

# see https://forge.puppetlabs.com/jamesnetherton/google_chrome
include google_chrome
#class{ "google_chrome":
#  version => "stable",
#}

# see https://forge.puppetlabs.com/gini/idea
class{ "idea::ultimate":
  version => "13.1.4",
}

# see http://docs.puppetlabs.com/references/latest/type.html#package
package { "git":
  ensure => present,
}
package { "rpm":
  ensure => present,
}

