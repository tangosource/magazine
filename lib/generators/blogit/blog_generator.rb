# CURRENT FILE :: lib/generators/team_page/team_page_generator.rb
# Requires
require 'rails/generators'
require 'rails/generators/migration'

class BlogGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  def self.source_root
    @source_root ||= File.join(File.dirname(__FILE__), 'templates')
  end

  def self.next_migration_number(dirname)
    if ActiveRecord::Base.timestamped_migrations
      Time.new.utc.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end

  def create_migration_file
    migration_template 'create_magazine_articles.rb', 'db/migrate/create_magazine_articles.rb'
    migration_template 'create_magazine_comments.rb', 'db/migrate/create_magazine_comments.rb'
  end
end