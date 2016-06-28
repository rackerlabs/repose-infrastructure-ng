# Setup users

class users {

  ssh_authorized_key { 'fsargent':
    ensure  => absent,
    type    => 'ssh-rsa',
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC4pL+84UzYmNVLRkEr4TYFbT65TVBh8/SAoNwZML0wRB7COr7q3v5E6xnAp31x9Ihw0p6DFOV7/BRd067FrCkrkxNrn/U0y+iuNll2ab3gG8n/6Aw2ehzAuJwlHGf0GUDMnLoNeFHGXwwTiLM2qm3zlxe++lO1WRmBGPybBGG/DG4wyidLHJUZ8l7UFO29y7/K9X/Q77Ln5587qpZwWkAyQoH21rRO/goSOTtYzs40IWFZcxOiN9pL7aZQ0/k7dnepP62spCT7xhJcbKEYVyZtM62zFYI7jWH6pJSzVKvEu0bPrGeuGgE8aKJQvHEwVO/gFtupb7DsXblXSkdkjV0Z',
    name    => 'fsargent@-fsargent-mbp.local.-',
    user    => 'root'
  }
  
  ssh_authorized_key { 'mknocke':
    ensure  => absent,
    type    => 'ssh-rsa',
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQC8yMjwIkV3i3IsmXIf4mJg3UlcRX0epZQw5hEpnDrZRAUe7SU42lB5nt/Q9GtyuZNXZuqnPLKBvm87cluvgtE6OK1ZBDxaUavofJlWIpsNhNzWZpDBeETFR3BnOL4yklBnEHqdf6zlfzX02J1GvYdNK3ZDHx2lpHPdvUQkLx1DUcCdCqzRCJcTX55N3k5HMzcnaFgcCJr8URK6Lo0LX34y3RLY4opmuhh5Dn+sdnxja3JRzAuEuD4kXWRd2HSSUMYNCOoTUNTH20yldHvpKETGT7bmWI7am60waS6pbIfJPaOpD5opGQHVpuh3y3RdKgvIXNozpBR8gGgMJO5/aeDEwuG+s8uSQdizsE9naoTDEsNPkwsJU2avLNr9L9VFTPnGotyJQcEiGKLQJl/vi/+Rps3B+55rhYAOMHsXK4MYR2WTkexFSL84XX6gFqNStXT4L3rwiOaNbtOr4Dyt9sp9JPYoQm3aJ/MHDETP4Ta6YGTgCYyVw+S6VSysq2IEfKoP7FNdlvLIfjullMdnNO1BbVW84XGRTouPc146qx/Vw5u8sNaLvhkxoUMy8WVvLQ1d8sV2COLoNrWU9J5GQ+DVQ+noK46d8/g4dhUsgIfhPlE/qCNndvPE7JyqSzcEev4pp6Y7JRyid2mCuQf56UyDQSS8kJPM7aK7oh/ubAAxpQ==',
    name    => 'megan.knocke@rackspace.com',
    user    => 'root'
  }

  ssh_authorized_key { 'ageorge':
    ensure  => present,
    type    => 'ssh-rsa',
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCsa6ProZstDzlYMSKzrhTXmaNaUSYFQAd4kC1QTBajgJkYS4KwH3HmJlkrYgwzjFYXLLs6qkOzilg2bvgmmeJqgwX5mUXrkg32As0CPeefHQYv4tatXmv5Ztgao2tnLEAP/z1O5YRx5EiTuCPo/NIWZXtzlgjC+VteP3WO/l5q7SLzoGla9aykmS1TzvgdwRuKuQM2MH0mACgYvbGVzXHgWjxbGjcYrRz10itqHYluxtrGqukBsagE51OLW6E7U+z/pI2g9lgTD6tzUDmQqfGky09oXrR66Sp1iTxmAAd9ohcAkEcyVJOpOqDFsDcISr3CNDgj7j5f24pkbHnU1p3l',
    name    => 'adrian@adrian-laptop',
    user    => 'root'
  }

  ssh_authorized_key { 'also-ageorge':
    ensure  => present,
    type    => 'ssh-rsa',
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC6fxFsPwiURedznpuhCTHC3wsJAU5OxgFgD//wtWSJm5ePCJ1KvYD8eXZt79sIK+B17rAmLwGhkeS1YR3LQYnxuSdA9IQ6ioZP4XX5tsotMKo696ZtDVfsl/APtUSUyXcTqPy3tCSiq8MFVT1DYwaChJzLUZx8uan2Hoaq+vLx+aXpMRHUvOkEkqyQryHJFRTOXKQVDzN/9FV6rEo5wqC+7SUrOV0pvzOH4SGotHW/COoPdxJzqs1oFg7AAoVLqCo/SkChGgTeiLZMLwe1Z/KorBYzpsECprEZBe6B4dRxTjTooCgLl8O+5/CPgpjksRzeLlbgW1IGwIsPa02YJ7Xr',
    name    => 'adrian@work-desktop',
    user    => 'root'
  }

  ssh_authorized_key { 'dkowis':
    ensure  => absent,
    type    => 'ssh-rsa',
    key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA9NcNiDKjl/K5R4Qk3F6IaF9dx2ZrUGlr5tdhwiqmfOWq6eZ+I60ZL0tKzhuE37tF9VMN8U89nHgQa/wOWkfDmLX20TuT3XHMXxc+3WS2g/iocS7JdBacayhgmcYDdDlUwHgvWvKk0wPO2/6UjmO4EXNwZHsdFR0JA40tAScuY9/Mf5ECB/dgxgNtVRfbjLNTFBF5ExAjoI15w1GhqONCOmAXH9CqlBokARqm8kPPuYKM6iCwmPeerhsVD5oR3DrEqHebCNVSevN2j21Nzoz8C1y1m7UMZ55VaQC8AM3f90mo4Tqw9ZTJbp4ctGYdhI/DyFS2APgvEua94aPwLjPLSQ==',
    name    => 'dkowis@dkowis-desktop',
    user    => 'root'
  }

  ssh_authorized_key { 'dmnjohns':
    ensure  => present,
    type    => 'ssh-rsa',
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCpVUcqEZdhmjjzyk+X33mxs7P09zUxwcQjC5wXtZ+7ij/0RYf9Y7dLmm5tsGJjN3R3NLj69oek4oyZ1dtGWuMkpioUvpyQAmy/nQQxEuz+/cqOOnKdGPflMq/vfHD9nv43AzzOyO/W+56X5KWs1n7TrEp44b55RevU1GtStQ/KBrRZBML8VILC8HA5i5Arl4gLp8O75HGsCgBrzKdRH7KBD4Y5xpnWbwhqGZxtAKxdV/KKVb4ZGxmyg2tv10XvM+9mW6/jLr1uhzZWXWIdQVHLpI4gcNO46VPMlWePn+LzPIHi/DQmPP99eoA6lDJ58lW35WQAa+TdphHKmgQvW3qr',
    name    => 'damien.johnson@rackspace.com',
    user    => 'root'
  }

  ssh_authorized_key { 'wdschei':
    ensure  => present,
    type    => 'ssh-rsa',
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCteXpnTualvy4cAgsVUcC76GvjB9LtW9YkjnfeJOlLMFlP1r9JJW3UpIe3vmKvjK8asb7L72N1PyGf3wCNhwQJOGXWmDL39R+/TGa8gE9XhtTjzJgSE9iUlCy1SrQyDWz0n6SpP44t2+aUI6esP7LMKZ+pR/YJig1ndWZPIy586LCkQTAEz0hk96OnIv/umRVLR+CE6kc9Z3akZ8Yg7KcdvbNRZ2657oct2YWkCm5yh7Zg1/46XK42yZzjKnoHbDp1rXIFrS4XOqmx0ahVGU3HputJVGV76EyEHlf9O5kmqgobtu6tMj6m/VF7FFhAt7lHtsH3u7+5DS5FwInFNgLP',
    name    => 'bill7601@Scheidegger',
    user    => 'root'
  }

  ssh_authorized_key { 'troyal':
    ensure  => absent,
    type    => 'ssh-rsa',
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDgcUdZ2PvIMbX/7hnsLCWLuOrLD75uWKxoFxJZqlcjx789SjyticqMuDydK5z9f82BCtTs8sFdH3+nm9O4v3JdGeYYIKNaYxXcG/IIEZZ7bs99rTzBsexkGHODYb8/PcAqMcivSeYqfoy3qqgDwP49S/K6Vbv+/yEQVCUL1E/fUpTjd6ZDt8nS3ohfcmf8dOLKHKety+jumrQwoHsAwYhVjAGrF+DmGhlCCTd7twtbd5L7nQRjwAhW8A7EZDXTIdrWh4rM2vmNYDbzgoSPVGkwAG8GlQk3QgA2/CN0epEr179SP3ArZhQ96n3KhEooifoRD/ACTDbjK8MsCwTagmB9',
    name    => 'tyler@tyler-laptop',
    user    => 'root'
  }
  
  ssh_authorized_key { 'dimi5963':
    ensure  => present,
    type    => 'ssh-rsa',
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCmzYB+v6yjDaoAgPgcStdydVpaajj8Qz7M6NDFQGo6TZOfT6+R/ERcw3sVUE3e36IZTE1HhclYfmEPpy6G7DxezLTIaYLdJ41nWavl+SUs+QpIH+ww4RDWgStDS9eN2Ytpfo4/HAREz+JYO/CDG++KkufD63A4rg0ZLJWs4QNffdMvTllNvIr/3aNuL5udJ7UI+kk3aPVWMHi6yHcu7jwFNia8yrEdCxBSoZjU5Obp4sQdVR7Cp98LgBSTYBY2ysL0qkRAqqN/NM5DAW51IIrffp1u7Wb1atFpHqN6XyrrT/Juz+pLYyMYsiLmJkcQyM7kACywDqQlb5IgLw9dlFRR',
    name    => 'dimitry.ushakov@rackspace.com',
    user    => 'root'
  }

  ssh_authorized_key { 'mari9064':
    ensure  => present,
    type    => 'ssh-rsa',
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQC7WTU/1utwo99vNlhF2zji5vk66eaXtc96CQipDuVzO8t3kiB9zOCai65hT1etgaDYaDqUVKYS3daiAJ6gtiqpuIqMxFWXSCLQfK01Zn0mJbmx1+8X+ZTMuxNN6FuTxUeBmC7ISc8ziloMCVbQTQ62uJxal/2RZekTcABXc2kLen7O9HynQOIvxmw9cVhiIYJUPm7WIoGfSEcXuHyhHYbnQCa6Kdk4Kw/kjJSeCxq1ak8ZlkeLuRqcdlAyS5jgGnKOkxuLnUW1IBzB98wR5E6ZkAM5RXEQIqhmuK+FKZvQkM08fDm6u7aOIUER0/z+WTI8q6ya3Ms5ML6bxPI/p5+KEIfFivHre4SpLOZp7fiB/qL0PEfWjLmvLSJJfA97nDj6TJSZSWT3iCQW9qlYTnBxb5IQAV5qaUjj1jBgJY7NVlc+bqt+onGd2T2JqtUyWbSSQhIeCRZ8TejRNVggRaTi113ZMyjI9k9QlrUoKpazRLaA3j+QjTu7tUszPmLb157e7V1/MkUl7mpnpdTLrz+3gyVWBbOPacQtgdORvsMTOzvjivmrCbvWhS9mcjLE39ADHJwS0tOfEKYaCFI6lB90VBcRdNXuyJXtNEOsM/XX1aZeFrJy1YRcBRxlv0nk3VmDSs9rE5WSUcXMXpUvzLMr2jcCCcQ7TOhl4Xza32P5YQ==',
    name    => 'Mario.Lopez@rackspace.com',
    user    => 'root'
  }

  ssh_authorized_key { 'joelrizner':
    ensure  => present,
    type    => 'ssh-rsa',
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDJY7WfQyYhH5RAN4MkmNswgYAoXhCuS1f1jbtH43zcTdy+A3ts0A5ej7WuiLUcIEeSfLbVfrxJnRTVGg1d6nmHdh1lGFsh+khvbTkdtC87pSQSMFMmdZAyY9VSBJwrSm9k/BNUWTX9JzSawA8Qz+rKb6qqRXQvRXEPjkFhv1XaC+lo7oWyiw4LpFj4ddzuhaqotsOYHIwzjPmvVrph4Pfm98a3tiWWi20SC4IhTaWTZpLmjqd5TGkXOjwz/B7I3OJLNC5V3+2mxAhrlrnOucAGSTw9NhCEiS3gdH3VGb8BJecFHqAR7H9WkH4ZQmbp9IBk1UOem3dqc0/FWeNFvLQYrkvVfEnzgRNJwXmsRgWiEm6HH5Lyx5CfdCeasCsUTnP2oxzNSXs2v7AKYV81l9dWZqkql+K4y+c0d1haD+UB2KIJOuvunOE/ERP5oO4QghefFdCg5AKJmBl1mU/Wm7m0HnUER2OfU6hiC5LsMMahn3o5HIH50wR42Hd7KM+79DSGy8vtoM1QemoiZIXSKvnEfgwXoAL/SdgaVIn8wS1niJLZHyt3T3yUSCfBQfpzdo9ttH636F+AkSvXarS4TwLZTt+Cm3dbACz+bDmVAOrnRDLkETWNcAK2+EWeLPFgeJGgmIuS0yZ0Brch9dVvfGoPLVgM5l+sgAtwjbuornMxiQ==',
    name    => 'Joel.Rizner@rackspace.com',
    user    => 'root'
  }
}
