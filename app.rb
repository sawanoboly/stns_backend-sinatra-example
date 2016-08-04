require 'sinatra/base'
require 'yaml'
require 'json'

class MyApp < Sinatra::Base
  @users = YAML.load(File.read('./data/users.yml'))
  @groups = YAML.load(File.read('./data/groups.yml'))

  ERROR_MSG = '{"Error": "Resource not found"}'

  def users
    self.class.instance_variable_get(:@users)
  end

  def groups
    self.class.instance_variable_get(:@groups)
  end

  get('/') { "Hello STNS." }

  get('/user/name/:username') do
    if users.has_key?(params['username'])
      res = {}
      res[params['username']] = users[params['username']]
    JSON.pretty_generate(res)
    else
      ERROR_MSG
    end
  end

  get('/group/name/:groupname') do
    if groups.has_key?(params['groupname'])
      res = {}
      res[params['groupname']] = users[params['groupname']]
    JSON.pretty_generate(res)
    else
      ERROR_MSG
    end
  end

  get('/user/list') do
    JSON.pretty_generate(users)
  end

  get('/group/list') do
    JSON.pretty_generate(groups)
  end

  get('/user/id/:uid') do
    user = users.find {|k,v| v['id'] == params['uid'].to_i }
    if user
      JSON.pretty_generate({user[0] => user[1]})
    else
      ERROR_MSG
    end
  end

  get('/group/id/:gid') do
    group = groups.find {|k,v| v['id'] == params['gid'].to_i }
    if group
      JSON.pretty_generate({group[0] => group[1]})
    else
      ERROR_MSG
    end
  end
end
