table_names = ActiveRecord::Base.connection.tables - %w(users authentications schema_migrations)
table_names.each {|table_name| ActiveRecord::Base.connection.execute("TRUNCATE #{table_name}")}

Dir.open('db/migrate').each do |fname|
  i = fname.split('_').first.to_i
  next if i == 0
  ActiveRecord::Base.connection.execute("INSERT INTO schema_migrations (version) VALUES(#{i})")
end
