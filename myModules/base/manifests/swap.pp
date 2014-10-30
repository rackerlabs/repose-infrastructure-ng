# Manages swapspace on a node.
#
# Based on https://gist.github.com/Yggdrasil/3918632
#
# Parameters:
# - $ensure Allows creation or removal of swapspace and the corresponding file.
# - $swapfile Defaults to /mnt which is a fast ephemeral filesystem on EC2 instances.
#             This keeps performance reasonable while avoiding I/O charges on EBS.
# - $swapsize Size of the swapfile in MB. Defaults to memory size.
#
# Actions:
#   Creates and mounts a swapfile.
#   Umounts and removes a swapfile.
#
# Sample Usage:
#   common::swap { 'swap':
#     ensure => present,
#   }
#
#   common::swap { 'swap':
#     ensure => absent,
#   }
#
define base::swap (
    $ensure       = 'present',
    $swapfile     = '/mnt/swap1',
    $swapsize     = $::memorysize_mb
) {
    $swapsizes = split("${swapsize}",'[.]')
    $swapfilesize = $swapsizes[0]

    file_line { "swap_fstab_line_${swapfile}":
        ensure  => $ensure,
        line    => "${swapfile} swap swap defaults 0 0",
        path    => "/etc/fstab",
        match   => "${swapfile}",
    }

    if $ensure == 'present' {
        exec { 'Create swap file':
            command => "/bin/dd if=/dev/zero of=${swapfile} bs=1M count=${swapfilesize}",
            creates => $swapfile,
        }

        exec { 'Attach swap file':
            command => "/sbin/mkswap ${swapfile} && /sbin/swapon ${swapfile}",
            require => Exec['Create swap file'],
            unless  => "/sbin/swapon -s | grep ${swapfile}",
        }

    } elsif $ensure == 'absent' {
        exec { 'Detach swap file':
            command => "/sbin/swapoff ${swapfile}",
            onlyif  => "/sbin/swapon -s | grep ${swapfile}",
        }
        file { $swapfile:
            ensure  => absent,
            require => Exec['Detach swap file'],
            backup  => false
        }

    }
}
