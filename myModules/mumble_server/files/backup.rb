#!/usr/bin/env ruby

# MANAGED BY PUPPET

# a script to live backup the mumble database, and copy it to a backuppable location
# and then call the real backup script
# inspired by: https://gist.github.com/willb/3518892

require 'sqlite3'
require 'fileutils'

def backup_db(db_file, backup_file)
    begin
        db = SQLite3::Database.new(db_file)
        db.transaction(:immediate) do |ignored|
            # starting a transaction with ":immediate" means we get a shared lock
            # and thus any db writes (unlikely!) complete before we copy the file
            FileUtils.cp(db_file, backup_file, :preserve => true)
        end
    ensure
        db.close
    end
end

backup_db('/var/lib/mumble-server/mumble-server.sqlite', '/srv/mumble_database/mumble-server.sqlite')

# after the database is backed up call the backup script!
exec('/usr/local/bin/duplicity_mumble_database.rb')