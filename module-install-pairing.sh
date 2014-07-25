#!/bin/bash

# Install the required modules and dependencies.
# Since this is intended for use installs w/o access to the puppet-master,
# the librarian-puppet was overkill.
#
# NOTE: Dependency management is manual!!!
#       IF you add/change anything,
#       THEN you must check the dependencies too.
#
puppet module install puppetlabs-stdlib            --version 4.3.2 &&
puppet module install puppetlabs-apt               --version 1.5.2 &&
puppet module install puppetlabs-java              --version 1.1.1 &&

puppet module install darin-zypprepo               --version 1.0.1 &&
puppet module install jamesnetherton-google_chrome --version 0.1.0 &&

puppet module install maestrodev-wget              --version 1.4.5 &&
puppet module install maestrodev-maven             --version 1.2.0 &&

puppet module install gini-archive                 --version 0.2.0 &&
puppet module install gini-idea                    --version 0.2.0

