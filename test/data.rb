class Foo
  include DataMapper::Resource
  property :id,    Serial
  property :money, Currency

end

DataMapper.setup(:default, 'sqlite3::memory:')
DataMapper.auto_migrate! if defined?(DataMapper)
