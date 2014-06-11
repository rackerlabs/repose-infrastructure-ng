# Jenkins Slave SSH Keys for Repository

class users {

    ssh_authorized_key {'repose-jenkins-01':
        ensure  => present,
        type    => 'ssh-rsa',
        key     => 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAuy/VESlo9iZAa9YQbEv9JGvvEsRKC3HxW2XivlDchGOxUNfrdaBGtFjMPe5rf6Qlv1hJ8bvHqZgCQIWYigRF45GXPJXGCaMWFoADG5+Mtr4SfoOWE8i6rVRphaKdIDV+UlhNQWlr4Cw/K4sgJB671qbSQjkn1H2uHiECMB1iUBtE8aOyDQm2bNzHh2sVyrDbUDm7zU354dIo84r3HhHVsK+3d0IhkiIhtWXc7IH4wL0pJ8B2Iv6FVLsQlY+pibGBPQzns25j83bPN01tj2JAxe6EqgsUyIJVu3Hb4UpFWkWquLQnOg0xbRHP/UnK5bQb/NI1ly/HKvt9xxQH8cEERQ=='
        name    => 'jenkins@repose-jenkins-01',
        user    => 'root'
    }

    ssh_authorized_key {'repose-jenkins-slave-01':
        ensure  => present,
        type    => 'ssh-rsa',
        key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA4+ddqYSzecGghjTsXkzlozUPYwQ8GryGhXjw5w43ls8CvvGudACAfAZrk/RpWbn1sIZEdBed9b5yM+HcMdl7HUvyxazwHMEzVG96VoBsQpUTQpl3374CjxMejnELrgsRUl/O47cBkdWLWkBZaKN3eQal7XcabDuno2kGt/R1sZp4zK+edLeL3m7lABj7FLMIOXnbG9GI2GNkZE3W5t7j21r1+f1nUILfw1105nAyRpOHCpnVCceXvUy/w1oIm0g9RT43DK0DEpB9p5dTV42PL6peHmBY9bWxj8yDzJsgrWMbIg9jgdSkmDAssvFgNGIOrUixPEMEPf8adsXiq3t2VQ=='
        name    => 'jenkins@repose-jenkins-slave-01',
        user    => 'root'
    }
    ssh_authorized_key {'jenkins@repose-jenkins-slave-02':
        ensure  => present,
        type    => 'ssh-rsa',
        key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAwFwf8WQjYj2WuVksh80zAl9ReqgaYd2CSdBLOsie5xpbd9F2IynqyGgBeKo0RM9skWRmPXD4LKnbVqURBoyyCwN8Q/gtR/Ft4RWjuUSeCONedkwXBTzTEsi+ZPvyfr3qZeXo5ppPdUE1a47Mq3Ww3kKKu5gwOZX32q3VYR9ICi2sQFrSnQmOTPn0ssvJKkxzlrRo68Vi3WSVqShlCxQdFU0ae4BNXE2zT0l0mOsUvqcWYmv9ryZaFX5zuIsnizlRsGwrtGVAhMj4jnqAoN2LVGJL8GC2OXqtkWG/Igfzep/vbuic481w5dhLhn8f024YG5hyHYSqamnPfuK7o8MJ3Q==',
        name    => 'jenkins@repose-jenkins-slave-02',
        user    => 'root'
    }
    ssh_authorized_key {' jenkins@repose-jenkins-slave-04':
        ensure  => present,
        type    => 'ssh-rsa',
        key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA41ExOE69QxJx0DkXsr2Pu6Wy/wWMd5k3aTqFlGR3Hl4rm7sala80jaacpuD8dKHMHJigQTMWR1H0M8P4YjRXElmm7jL2CStWCCV7HoG+qAdMSmBqIJGyJOu9nFewMf5+77AAb8GGxO14BF3PvNMDqTvvnxGQK+qb/QLg9kDTIojo2Q38JMDcjUh0ptUFyMsKrHt+e4m/ParXpLE8HlIqVGTbkWDROmfELB8L86Raglye+2+OKGSW2TziNMvgQ4hng0mI1YJxJD65NBwa+8a3ApV0WOmSkRjtBZ8z04krEzlQbtwtnwVioYFivxOwrLZHAouERs/ttbLqnH8fYqFCcQ==',
        name    => ' jenkins@repose-jenkins-slave-04',
        user    => 'root'
    }
    ssh_authorized_key {'jenkins@repose-jenkins-slave-03':
        ensure  => present,
        type    => 'ssh-rsa',
        key     => 'AAAAB3NzaC1yc2EAAAABIwAAAQEA4bNSCJX6hGOxGUEIAvnAcc1lgjLxgLqa1bFuIzbHAqf5DBdADMidxnz/ubq8j4PjiINgaHskuPwIGKakM9xVAapQJo4H3yPCioKmQ5mIcyE3FbZ8moAvsoqJUc/LnWzMdYUAa9SMWDgn9GIao7wn00I6RbR3RmiDG7Ii+27TWoFeBO0J53nL4sLNW9pmiWlxGJliZLhTe10Vz5mezHDFcclompOyAOAo6vKqYdCMKcm6/gwUcRGCWdu6n6NnjDhXZ7eUyK7ntFfmza7dbimym4WgfNOKF3Q4mCjl6EyYgz1xc1wlaLDEJfjfpobhECbGFmPRwJkvKZc92qKTtNkiVw==',
        name    => 'jenkins@repose-jenkins-slave-03',
        user    => 'root'
    }
   
    

}
