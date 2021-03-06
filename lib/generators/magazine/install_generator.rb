module Magazine
  module Generators
    class InstallGenerator < Rails::Generators::Base
      
      source_root File.expand_path('../../templates', __FILE__)

      desc "Creates a Magazine initializer in your application's config/initializers dir"

      def copy_initializer
        template "magazine.rb", "config/initializers/magazine.rb"
      end

		  include Rails::Generators::Migration

		  def self.next_migration_number(dirname)
		    if ActiveRecord::Base.timestamped_migrations
					milliseconds = Time.now
					"%10.6f" % milliseconds.to_f
					milliseconds = milliseconds.usec
		      t = Time.new.utc.strftime("%Y%m%d%H%M%S")
					t = t.to_s + milliseconds.to_s
		    else
		      "%.3d" % (current_migration_number(dirname) + 1)
		    end
		  end

		  def create_migration_file
        migration_template 'add_default_image_to_images.rb', 'db/migrate/add_default_image_to_images.rb'
        migration_template 'add_name_and_alt_name_to_images.rb', 'db/migrate/add_name_and_alt_name_to_images.rb'
		    migration_template 'add_random_string_to_images.rb', 'db/migrate/add_random_string_to_images.rb'
        migration_template 'fix_images_field.rb', 'db/migrate/fix_images_field.rb'
        migration_template 'add_date_published_to_articles.rb', 'db/migrate/add_date_published_to_articles.rb'
        migration_template 'create_images.rb', 'db/migrate/create_images.rb'
        migration_template 'create_articles.rb', 'db/migrate/create_articles.rb'
        migration_template 'create_article_comments.rb', 'db/migrate/create_article_comments.rb'
        migration_template 'add_needs_review_to_articles.rb', 'db/migrate/add_needs_review_to_articles.rb'
		    migration_template 'add_featured_to_articles.rb', 'db/migrate/add_featured_to_articles.rb'
		    migration_template 'add_published_to_articles.rb', 'db/migrate/add_published_to_articles.rb'
		  end
		end
  end
end
