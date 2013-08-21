require "fog"

desc "Backup server and clean old backups"
task :backup => ['backup:run', 'backup:clean']

namespace :backup do

  desc "Backup server - database and all user data will be backed up"
  task :run => :environment do
    start = Time.now
    # Flush and lock all the DB tables. Rails will block on actions that write to the DB
    # until the tables are unlocked. This should be transparent to web users, asside from
    # a short delay in the app response time. Entire :backup task only takes a few seconds.
    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection.execute("FLUSH TABLES WITH READ LOCK")
    # Fush Ext3 file system cache to disk
    system("sync")
    # Create EBS snapshot. We only have one instance and one EBS volume, just select that volume
    fog = Fog::Compute.new(:provider => 'AWS', :aws_access_key_id => Rubber.config.cloud_providers.aws.access_key, :aws_secret_access_key => Rubber.config.cloud_providers.aws.secret_access_key)
    volume_id = Rubber.instances.first.volumes.first
    puts "Creating snapshot of #{volume_id}."
    snap = fog.snapshots.new :volume_id => volume_id, :description => "Nightly backup of #{Rubber.instances.first.name}"
    snap.save
    # unlock tables
    ActiveRecord::Base.connection.execute("UNLOCK TABLES")
    puts "System backup completed in %.1f seconds." % [Time.now - start]
  end

  desc "Clean up old snapshots - keep daily snapshots for 1 month, keep monthly snapshots indefinitely"
  task :clean => :environment do
    start = Time.now
    fog = Fog::Compute.new(:provider => 'AWS', :aws_access_key_id => Rubber.config.cloud_providers.aws.access_key, :aws_secret_access_key => Rubber.config.cloud_providers.aws.secret_access_key)
    volume_id = Rubber.instances.first.volumes.first
    fog.snapshots.all.each do |snapshot|
      if snapshot.volume_id==volume_id || snapshot.volume_id=='vol-e6b5fc9d'  # (hack the PSIApps volume in here for now - vol-e6b5fc9d)
        if snapshot.created_at < 31.days.ago && snapshot.created_at.day!=1
          puts "DELETING #{snapshot.id} (#{snapshot.created_at.strftime('%b %-d, %Y')}) for #{snapshot.volume_id} (#{snapshot.volume_size}mb)"
          fog.delete_snapshot(snapshot.id)
        else
          puts "Keeping #{snapshot.id} (#{snapshot.created_at.strftime('%b %-d, %Y')}) for #{snapshot.volume_id} (#{snapshot.volume_size}mb)"
        end
      end
    end
    puts "Clean backups completed in %.1f seconds." % [Time.now - start]
  end
end