class Foo
  include DataMapper::Resource
  property :id,    Serial
  property :money, Currency
end

class Bar
  include DataMapper::Resource
  property :id,    Serial
  property :money, Currency, :precision => 3, :separator => '^'
end

DataMapper.setup(:default, 'sqlite3::memory:')
DataMapper.auto_migrate! if defined?(DataMapper)
