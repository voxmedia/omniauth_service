require 'active_record'

# create DB
ActiveRecord::Base.establish_connection({
  :adapter  => "sqlite3",
  :database => ":memory:"
})
# create tables
load File.expand_path('./schema.rb', File.dirname(__FILE__))
# define the models
require_relative './models'


# Monkey patch to ensure each test is run in a rolled back transaction
class MiniTest::Spec
  def run( *args, &block )
    value = nil
    begin
      ActiveRecord::Base.connection.transaction do
        value = super
        raise ActiveRecord::Rollback
      end
    rescue ActiveRecord::Rollback
    end
    return value  # The result of run must be always returned for the pretty dots to show up
  end
end

