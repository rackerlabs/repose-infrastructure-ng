It's recommended that you set up the --archive-dir path to something that has enough space to store the most recent tarball.

It's what duplicity uses to create the local archive before uploading it.

Probably wisest to mount something to `/var/cache/duplicity` and then `--archive-dir=/var/cache/duplicity`

It's not strictly necessary, but it'll use ~/.cache/duplicity instead (which will probably be root's homedir.)