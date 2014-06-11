class git {
  package {'git':
    ensure => present,
  }

  package {'gitk':
    ensure => present,
  }
}
