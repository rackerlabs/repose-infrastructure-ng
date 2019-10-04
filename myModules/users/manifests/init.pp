# Setup users

class users {

  ssh_authorized_key { 'wmendizabal':
    ensure  => present,
    type    => 'ssh-rsa',
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDAwUPaRzOm9w+j9S4QkggkZpaiUUBLemV+Bme1aMkZ5UpnIkaZWcFtXcrS8Uwcn++ZQaQylECz9Rg5IM3IR8WjpGkFP3pR/mmFT0SvurbEG1pUrCp/ULNVcVPP6QloI5yO/fyzHpjJebEVhR1lPlyp2+vx6ox87mcHFz6uaOxWHRbOqSBrEe7oggpWoVTK3chyBxRB7GQlU8QqWO+2scYdKPtgOfaF5u3+chYK7dYrYn23lvBH6E1Gp1DunFB7hOn3FLkRZXHSurWp52eIBNRih7UxquqUH1R/9AHQTPqnsEwc6T7nl/xBY36MfdL3zzzLNPuMcupaoVqCXpG1cImB',
    name    => 'werner@pro',
    user    => 'root'
  }

  ssh_authorized_key { 'ageorge':
    ensure  => absent,
    type    => 'ssh-rsa',
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQCsa6ProZstDzlYMSKzrhTXmaNaUSYFQAd4kC1QTBajgJkYS4KwH3HmJlkrYgwzjFYXLLs6qkOzilg2bvgmmeJqgwX5mUXrkg32As0CPeefHQYv4tatXmv5Ztgao2tnLEAP/z1O5YRx5EiTuCPo/NIWZXtzlgjC+VteP3WO/l5q7SLzoGla9aykmS1TzvgdwRuKuQM2MH0mACgYvbGVzXHgWjxbGjcYrRz10itqHYluxtrGqukBsagE51OLW6E7U+z/pI2g9lgTD6tzUDmQqfGky09oXrR66Sp1iTxmAAd9ohcAkEcyVJOpOqDFsDcISr3CNDgj7j5f24pkbHnU1p3l',
    name    => 'adrian@adrian-laptop',
    user    => 'root'
  }

  ssh_authorized_key { 'also-ageorge':
    ensure  => absent,
    type    => 'ssh-rsa',
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDCfEUA4mKVU9pFqfVZ1b32r3TJ64LnvtSUItUz8OL5qe8wqh0jLK5ei+xONYSG1C1+SC6WozEHlwfdW6VafWtGvGGkQ3U5DqlWdLFYsilIBN575kE/6QR1BXA/AoGXuZze6pouy/N3duLf/HB8Ct841XS++lI6xMjYOKZ2YXHs+9d8SfxEk+XtPj+ulwTIE4FX4zrpLqER1VdyNmBr0bn7ae5hxCNBPNc4pWdzEZG6oeXAIs4aSuuUAXwV+BkOw6ePlb+fQIcEzMufsiSETajLUM/hSTDzBYhMXeX7fBimJ2N14t59hdo4667RyD96a301RvZRsMO3rPjkLB99X9HbZVT1DOtpYGj8eDOALgzogm5NhJjeu6tSKrWAzeGJQzrDGFqxr6vbW9+646R4V0b6JuYCzTNZkJ9127pYQGcik/nKeh6ARJMWcL25f+/eDzTM0FiZAs71K6PfeBWmR074Qc3JUNhSh3rgHpAy1VZjBWh+FBO9HRLXRloe9h8saNX+g2X+kGl8BD3Bo81ZZ9poKcTdhAlhtGQc4SGZIkXg5sGeYyvliCeLx3bm6ZOAXUV17s5CPStuEXqg9OekHCr/lNqFqzixUdRz8Yz8g9zDHHEO6dQVCnHT84XTMSLNzoO7gWMltZ3xSJ09Q+O2DDy56VYCsHuQf3Y7HLfgXTwQAQ==',
    name    => 'adrian@adrian-new-work-laptop',
    user    => 'root'
  }
}
