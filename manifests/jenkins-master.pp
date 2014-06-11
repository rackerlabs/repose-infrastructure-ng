include jenkins
include jenkins::master

include cloud_monitoring

#Build Pipeline
jenkins::plugin {'http://updates.jenkins-ci.org/download/plugins/build-pipeline-plugin/1.4.2/build-pipeline-plugin.hpi':
    file    => 'build-pipeline-plugin.hpi',
}

#Copy Artifact
jenkins::plugin { 'http://updates.jenkins-ci.org/download/plugins/copyartifact/1.28/copyartifact.hpi':
    file => 'copyartifact.hpi'
}

#Dashboard View
jenkins::plugin {'http://updates.jenkins-ci.org/download/plugins/dashboard-view/2.9.2/dashboard-view.hpi':
    file    => 'dashboard-view.hpi',
}

#Github Api
jenkins::plugin {'http://updates.jenkins-ci.org/download/plugins/github-api/1.42/github-api.hpi':
    file    => 'github-api.hpi',
}

#Github
jenkins::plugin {'http://updates.jenkins-ci.org/download/plugins/github/1.6/github.hpi':
    file    => 'github.hpi',
}

#Github Pull Request Builder
jenkins::plugin {'http://updates.jenkins-ci.org/download/plugins/ghprb/1.8/ghprb.hpi':
    file    => 'ghprb.hpi',
}

#HTML Publisher
jenkins::plugin {'http://updates.jenkins-ci.org/download/plugins/htmlpublisher/1.2/htmlpublisher.hpi':
    file => 'htmlpublisher.hpi'
}

#Hudson Groovy Builder
jenkins::plugin {'http://updates.jenkins-ci.org/download/plugins/groovy/1.14/groovy.hpi':
    file    => 'groovy.hpi',
}

#Jenkins Email Extension
jenkins::plugin {'http://updates.jenkins-ci.org/download/plugins/email-ext/2.36/email-ext.hpi':
    file => 'email-ext.hpi'
}

#Jenkins Git Client
jenkins::plugin {'http://updates.jenkins-ci.org/download/plugins/git-client/1.4.6/git-client.hpi':
    file    => 'git-client.hpi',
}

#Jenkins Git
jenkins::plugin {'http://updates.jenkins-ci.org/download/plugins/git/2.0/git.hpi':
    file    => 'git.hpi',
}

#Jenkins Gradle
jenkins::plugin {'http://updates.jenkins-ci.org/download/plugins/gradle/1.23/gradle.hpi':
    file    => 'gradle.hpi',
}

#Jenkins JaCoCO
jenkins::plugin {'http://updates.jenkins-ci.org/download/plugins/jacoco/1.0.13/jacoco.hpi':
    file => 'jacoco.hpi'
}

#Jenkins jQuery
jenkins::plugin {'http://updates.jenkins-ci.org/download/plugins/jquery/1.7.2-1/jquery.hpi':
    file => 'jquery.hpi'
}

#Jenkins Maven Release
jenkins::plugin {'http://updates.jenkins-ci.org/download/plugins/m2release/0.12.0/m2release.hpi':
    file => 'm2release.hpi'
}

#Jenkins Multiple SCM
jenkins::plugin {'http://updates.jenkins-ci.org/download/plugins/multiple-scms/0.2/multiple-scms.hpi':
    file    => 'multiple-scms.hpi',
}

#Jenkins Paramterized Trigger
jenkins::plugin {'http://updates.jenkins-ci.org/download/plugins/parameterized-trigger/2.17/parameterized-trigger.hpi':
    file    => 'parameterized-trigger.hpi',
}

#Jenkins SSH
jenkins::plugin {'http://updates.jenkins-ci.org/download/plugins/ssh/2.3/ssh.hpi':
    file => 'ssh.hpi'
}

#Jenkins Workspace Cleanup
jenkins::plugin {'http://updates.jenkins-ci.org/download/plugins/ws-cleanup/0.19/ws-cleanup.hpi':
    file => 'ws-cleanup.hpi'
}

#Publish over SSH
jenkins::plugin {'http://updates.jenkins-ci.org/download/plugins/publish-over-ssh/1.10/publish-over-ssh.hpi':
    file => 'publish-over-ssh.hpi'
}

#SCM Api
jenkins::plugin {'http://updates.jenkins-ci.org/download/plugins/scm-api/0.2/scm-api.hpi':
    file => 'scm-api.hpi'
}

#SCM Sync Configuration
jenkins::plugin {'http://updates.jenkins-ci.org/download/plugins/scm-sync-configuration/0.0.7.3/scm-sync-configuration.hpi':
    file => 'scm-sync-configuration.hpi'
}

#Token Macro
jenkins::plugin {'http://updates.jenkins-ci.org/download/plugins/token-macro/1.9/token-macro.hpi':
    file    => 'token-macro.hpi',
}

#veracode-scanner
jenkins::plugin {'http://updates.jenkins-ci.org/download/plugins/veracode-scanner/1.4/veracode-scanner.hpi':
    file    => 'veracode-scanner.hpi',
}

#simple-theme-plugin
jenkins::plugin {'https://updates.jenkins-ci.org/download/plugins/simple-theme-plugin/0.3/simple-theme-plugin.hpi':
  file => 'simple-theme-plugin.hpi',
}

# join plugin to de-parallelize builds
jenkins::plugin {'https://updates.jenkins-ci.org/download/plugins/join/1.15/join.hpi':
    file => 'join.hpi',
}

# To have conditional buildsteps
jenkins::plugin {'https://updates.jenkins-ci.org/download/plugins/conditional-buildstep/1.3.3/conditional-buildstep.hpi':
    file => 'conditional-buildstep.hpi',
}
# run condition plugin
jenkins::plugin {'https://updates.jenkins-ci.org/download/plugins/run-condition/1.0/run-condition.hpi':
    file => 'run-condition.hpi',
}
# Token macro plugin needed by the runc ondition one
jenkins::plugin {'https://updates.jenkins-ci.org/download/plugins/token-macro/1.10/token-macro.hpi':
    file => 'token-macro.hpi',
}
