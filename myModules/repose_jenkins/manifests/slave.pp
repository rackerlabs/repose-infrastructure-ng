# Actually installs jenkins, rather than waiting for the master to push the JAR
class repose_jenkins::slave {
    include repose_jenkins
}
