# Actually installs jenkins, rather than waiting for the master to push the JAR
class repose_jenkins::slave(
    $jenkins_username = "nope",
    $jenkins_password = "nope"
) {
    include repose_jenkins

    $jenkins_home = '/var/lib/jenkins'

    class{ 'jenkins::slave':
        masterurl         => 'https://jenkins-proto.openrepose.org',
        version           => "1.15",
        ui_user           => $jenkins_username,
        ui_password       => $jenkins_password,
        manage_slave_user => 0,
        slave_user        => "jenkins",
        slave_home        => $jenkins_home,
        executors         => 1,
    }

}