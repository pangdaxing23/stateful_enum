# frozen_string_literal: true

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

# require logger before requiring rails, or Rails 6 fails to boot
require 'logger'
# Then load Rails
require 'rails'
require 'active_record'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'stateful_enum'
require 'stateful_enum/railtie'

if ActiveRecord::VERSION::MAJOR < 7
  Class.new(::Rails::Railtie) do
    module EnumSyntaxConverter
      def enum(name = nil, values = nil, **options, &block)
        return super options, &block if name == nil

        new_options = {}
        if (prefix = options.delete :prefix)
          new_options[:_prefix] = prefix
        end
        if (suffix = options.delete :suffix)
          new_options[:_suffix] = suffix
        end
        super new_options.merge(name => (values || options)), &block
      end
    end

    initializer :convert_old_enum_syntax, after: 'stateful_enum' do
      ActiveSupport.on_load :active_record do
        ::ActiveRecord::Base.extend EnumSyntaxConverter
      end
    end
  end
end

require File.expand_path("../../test/dummy/config/environment.rb", __FILE__)

ActiveRecord::Migration.verbose = false
verbosity, ENV['VERBOSE'] = ENV['VERBOSE'], 'false'
if ActiveRecord::Migrator.respond_to? :migrate
  ActiveRecord::Migrator.migrate(ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../test/dummy/db/migrate", __FILE__)])
else
  ActiveRecord::Migrator.migrations_paths << File.expand_path('../dummy/db/migrate', __FILE__)
  ActiveRecord::Tasks::DatabaseTasks.drop_current 'test'
  ActiveRecord::Tasks::DatabaseTasks.create_current 'test'
  ActiveRecord::Tasks::DatabaseTasks.migrate
end
ENV['VERBOSE'] = verbosity

require 'test/unit/rails/test_help'


# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
  ActionDispatch::IntegrationTest.fixture_path = ActiveSupport::TestCase.fixture_path
  ActiveSupport::TestCase.fixtures :all
end
