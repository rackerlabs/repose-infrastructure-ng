# Setup users

class users {

    ssh_authorized_key { 'fsargent':
        ensure  => absent,
        type    => 'ssh-rsa',
        key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC4pL+84UzYmNVLRkEr4TYFbT65TVBh8/SAoNwZML0wRB7COr7q3v5E6xnAp31x9Ihw0p6DFOV7/BRd067FrCkrkxNrn/U0y+iuNll2ab3gG8n/6Aw2ehzAuJwlHGf0GUDMnLoNeFHGXwwTiLM2qm3zlxe++lO1WRmBGPybBGG/DG4wyidLHJUZ8l7UFO29y7/K9X/Q77Ln5587qpZwWkAyQoH21rRO/goSOTtYzs40IWFZcxOiN9pL7aZQ0/k7dnepP62spCT7xhJcbKEYVyZtM62zFYI7jWH6pJSzVKvEu0bPrGeuGgE8aKJQvHEwVO/gFtupb7DsXblXSkdkjV0Z',
        name    => 'fsargent@-fsargent-mbp.local.-',
        user    => 'root'
    }

    ssh_authorized_key { 'ageorge':
        ensure  => present,
        type    => 'ssh-rsa',
        key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCsa6ProZstDzlYMSKzrhTXmaNaUSYFQAd4kC1QTBajgJkYS4KwH3HmJlkrYgwzjFYXLLs6qkOzilg2bvgmmeJqgwX5mUXrkg32As0CPeefHQYv4tatXmv5Ztgao2tnLEAP/z1O5YRx5EiTuCPo/NIWZXtzlgjC+VteP3WO/l5q7SLzoGla9aykmS1TzvgdwRuKuQM2MH0mACgYvbGVzXHgWjxbGjcYrRz10itqHYluxtrGqukBsagE51OLW6E7U+z/pI2g9lgTD6tzUDmQqfGky09oXrR66Sp1iTxmAAd9ohcAkEcyVJOpOqDFsDcISr3CNDgj7j5f24pkbHnU1p3l',
        name    => 'adrian@adrian-laptop',
        user    => 'root'
    }

    ssh_authorized_key { 'dkowis':
        ensure  => present,
        type    => 'ssh-rsa',
        key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA9NcNiDKjl/K5R4Qk3F6IaF9dx2ZrUGlr5tdhwiqmfOWq6eZ+I60ZL0tKzhuE37tF9VMN8U89nHgQa/wOWkfDmLX20TuT3XHMXxc+3WS2g/iocS7JdBacayhgmcYDdDlUwHgvWvKk0wPO2/6UjmO4EXNwZHsdFR0JA40tAScuY9/Mf5ECB/dgxgNtVRfbjLNTFBF5ExAjoI15w1GhqONCOmAXH9CqlBokARqm8kPPuYKM6iCwmPeerhsVD5oR3DrEqHebCNVSevN2j21Nzoz8C1y1m7UMZ55VaQC8AM3f90mo4Tqw9ZTJbp4ctGYdhI/DyFS2APgvEua94aPwLjPLSQ==',
        name    => 'dkowis@dkowis-desktop',
        user    => 'root'
    }

    ssh_authorized_key { 'dmnjohns':
        ensure  => present,
        type    => 'ssh-rsa',
        key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDO94bgx7CIosH5VH81mD6IGadg7x7KilWj/qMd6kdyC+9+1Q6Eg8vGO4d2nNCVZl9fFspcp87wPXFGrtbfcAqNicI6Q9gZD1z1rdLe+qw980Yd3vX6ncupM4GK94DUmLMjVXXk2ZOCyhqYkdIsO8zv3hCktqEfiez4Y1dRLCC9wq8Evh7FuTxvoE3pZpBANUAHOlnmZtFc/6pOyIz0vbnqYY8ih82pI1vLURialEkh3u3g0axm6L+zqoz5OvvTgmmUqExo32zYEycs9Fb9RpffjWzbYlPLj3zkHF+rB3hSJ8ivebuqofoVIvUdXS+CsHoqcnzGSGw5B7VqlBo3Blqd',
        name    => 'damien.johnson@rackspace.com',
        user    => 'root'
    }

}
