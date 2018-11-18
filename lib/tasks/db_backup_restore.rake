namespace :db do
  desc "Dumps the Database to db/seeddata/seeds.dump"
  task dump: :environment do
    with_config do |_app, host, db, user, pword|
      cmd = "PGPASSWORD='#{pword}' pg_dump --host=#{host} --username=#{user} "
      cmd += "--clean --no-owner --no-acl --format=c --file=#{Rails.root}/db/seeddata/seeds.dump #{db}"
      puts cmd
      exec cmd
    end
  end

  # NOTE: setting ENV variable PGPASSWORD will avoid user interaction
  # set PGPASSWORD=voyage_secret

  # NOTE: you can dump specific tables with multiple -t flags ==> -t users -t prereqs -t quests

  # dump all database tables, schemas, indexes, values, etc. (in custom binary format)
  # pg_dump --host=localhost --port=5432 --username=voyage_admin4 --clean --no-owner --no-acl --format=c --file=test.dump voyage_development
  # pword: voyage_secret

  # in plaintext (remove the --format option) -- this can't use pg_restore (use custom format for that)
  # set PGPASSWORD=voyage_secret
  # pg_dump --host=localhost --port=5432 --username=voyage_admin4 --clean --no-owner --no-acl --file=test.dump voyage_development

  task restore: :environment do
    with_config do |_app, host, db, user, pword|
      cmd = "PGPASSWORD='#{pword}' pg_restore --host=#{host} --username=#{user} --clean --no-owner --no-acl --format=c "
      cmd += "--dbname=#{db} #{Rails.root}/db/seeddata/seeds.dump"
      puts cmd
      exec cmd
    end
  end

  private

  def with_config
    yield Rails.application.class.parent_name.underscore,
      ActiveRecord::Base.connection_config[:host],
      ActiveRecord::Base.connection_config[:database],
      ActiveRecord::Base.connection_config[:username],
      ActiveRecord::Base.connection_config[:password]
  end
end
