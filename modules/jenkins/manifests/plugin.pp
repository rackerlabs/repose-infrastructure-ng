
# All the jenkins plugins
define jenkins::plugin (
    $file,
    $url = $title,
    $plugins_dir = '/var/lib/jenkins/plugins') {

    include jenkins
    
    common_utils::download { $url:
        file        => $file,
        target_dir  => $plugins_dir,
        require     => File[$plugins_dir],
        user        => 'jenkins',
    }
}
