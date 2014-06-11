class common_utils {
    $netcat_package = $operatingsystem ? {
        ubuntu => 'netcat',
        CentOS => 'nc',
        redhat => 'nc',
    }

    package {['wget', 'unzip', 'tar', 'curl', 'man', $netcat_package]:
        ensure => present,
    }

    define download ($url = $title, $file, $target_dir, $user = root, $timeout = 300) {
        exec { "download $file":
            command => "wget -O $file '$url'",
            path    => '/bin:/usr/bin',
            cwd     => "$target_dir",
            creates => "/$target_dir/$file",
            timeout => $timeout,
            require => [Package['wget']],
        }
    }

    define extract ($archive_name = $title, $exploded_archive_dir, $parent_dir, $user = root){
        $extractor = $archive_name ? {
            /.*\.tar\.gz/  => 'tar xf',
            /.*\.tar\.xz/  => 'tar xf',
            /.*\.tgz/      => 'tar xf',
            /.*\.tar\.bz2/ => 'tar xjf',
            /.*\.zip/      => 'unzip',
        }

        exec {"$extractor $parent_dir/$archive_name":
            path    => "/bin:/usr/bin",
            cwd     => "$parent_dir",
            creates => "$parent_dir/$exploded_archive_dir",
            require => [Package['tar'], Package['unzip']],
        }

        if $user != root {
            exec { "chown -R $user $exploded_archive_dir":
                path    => "/bin:/usr/bin",
                cwd     => "$parent_dir",
                unless  => "[ `stat -c %U $parent_dir/$exploded_archive_dir` = '$user' ]",
                require => Exec["$extractor $parent_dir/$archive_name"],
            }
        }
    }

    define download_and_extract ($url = $title, $archive_name, $exploded_archive_dir, $download_dir, $user = root, $timeout = 300) {
        download { "$url":
            file       => "$archive_name",
            target_dir => $download_dir,
            user       => $user,
            timeout    => $timeout,
        }

        extract { "$archive_name":
            exploded_archive_dir => $exploded_archive_dir,
            parent_dir           => $download_dir,
            require              => Download["$url"],
            user                 => $user,
        }  
    }
}