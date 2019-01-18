# Setup users

class users {

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
    key     => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQDCfEUA4mKVU9pFqfVZ1b32r3TJ64LnvtSUItUz8OL5qe8wqh0jLK5ei+xONYSG1C1+SC6WozEHlwfdW6VafWtGvGGkQ3U5DqlWdLFYsilIBN575kE/6QR1BXA/AoGXuZze6pouy/N3duLf/HB8Ct841XS++lI6xMjYOKZ2YXHs+9d8SfxEk+XtPj+ulwTIE4FX4zrpLqER1VdyNmBr0bn7ae5hxCNBPNc4pWdzEZG6oeXAIs4aSuuUAXwV+BkOw6ePlb+fQIcEzMufsiSETajLUM/hSTDzBYhMXeX7fBimJ2N14t59hdo4667RyD96a301RvZRsMO3rPjkLB99X9HbZVT1DOtpYGj8eDOALgzogm5NhJjeu6tSKrWAzeGJQzrDGFqxr6vbW9+646R4V0b6JuYCzTNZkJ9127pYQGcik/nKeh6ARJMWcL25f+/eDzTM0FiZAs71K6PfeBWmR074Qc3JUNhSh3rgHpAy1VZjBWh+FBO9HRLXRloe9h8saNX+g2X+kGl8BD3Bo81ZZ9poKcTdhAlhtGQc4SGZIkXg5sGeYyvliCeLx3bm6ZOAXUV17s5CPStuEXqg9OekHCr/lNqFqzixUdRz8Yz8g9zDHHEO6dQVCnHT84XTMSLNzoO7gWMltZ3xSJ09Q+O2DDy56VYCsHuQf3Y7HLfgXTwQAQ==',
    name    => 'adrian@adrian-new-work-laptop',
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

  ssh_authorized_key { 'dimi5963':
    ensure  => absent,
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
}
