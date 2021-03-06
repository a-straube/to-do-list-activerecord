require("sinatra")
require("sinatra/reloader")
require("sinatra/activerecord")
require("./lib/task")
require("./lib/list")
require("pg")
also_reload("lib/**/*.rb")

get('/') do
  @lists = List.all()
  erb(:index)
end

get("/lists/new") do
  erb(:list_form)
end

post("/lists") do
  name = params.fetch("name")
  list = List.new({:name => name, :id => nil})
  list.save()
  erb(:list_success)
end

get('/lists') do
  @lists = List.all()
  erb(:lists)
end

get('/lists/:id') do
  @list = List.find(params.fetch("id").to_i())
  @tasks = @list.tasks()
  # find tasks for specific list
  erb(:list)
end

post('/tasks') do
  description = params.fetch("description")
  list_id = params.fetch("list_id").to_i()
  @list = List.find(list_id)
  @task = Task.new({:description => description, :list_id => list_id, :done => false})
  @task.save()
  erb(:list_success)
end

get('/tasks/:id/edit') do
  @task = Task.find(params.fetch("id").to_i())
  erb(:task_edit)
end

patch('/tasks/:id') do
  description = params.fetch("description")
  @task = Task.find(params.fetch("id").to_i())
  @task.update({:description => description})
  @tasks = Task.all()
  @lists = List.all()
  erb(:index)
end

#get done
patch('/tasks_done/:id') do
  @task = Task.find(params.fetch("id").to_i())
  @task.update({:done => true})
  @tasks = Task.all()
  @lists = List.all()
  erb(:index)
end
