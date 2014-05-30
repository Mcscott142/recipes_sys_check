require 'sinatra'
require 'pry'
require 'pg'


def db_connection
  begin
    connection = PG.connect(dbname: 'recipessyscheck')

    yield(connection)

  ensure
    connection.close
  end
end


def find_recipes

  connection = PG.connect(dbname: 'recipessyscheck')
  results = connection.exec('SELECT recipes.id, recipes.name FROM recipes ORDER BY recipes.name')
  connection.close

  results
end

def get_recipe
 id = params[:id]
 query = ('SELECT recipes.id, recipes.name, recipes.description, recipes.instructions, ingredients.name AS ingname FROM recipes LEFT OUTER JOIN ingredients ON recipes.id = ingredients.recipe_id WHERE recipes.id = $1')

  results = db_connection do |conn|
    conn.exec_params(query, [id])
  end
  results
end


  # connection = PG.connect(dbname: 'recipessyscheck')
  # results = connection.exec('SELECT recipes.id, recipes.name, recipes.description, recipes.instructions, ingredients.name AS ingname FROM recipes LEFT OUTER JOIN ingredients ON recipes.id = ingredients.recipe_id')
  # connection.close

  # results
# end

# def get_ingredients
#   connection = PG.connect(dbname: 'recipessyscheck')
#   results = connection.exec('SELECT recipes.id, ingredients.name, ingredients.recipe_id FROM recipes LEFT OUTER JOIN ingredients ON recipes.id = ingredients.recipe_id')
#   connection.close

#   results
# end





get '/recipes' do
  @recipes = find_recipes

  erb :'/recipes/index'
end

get '/recipes/:id' do
@ingredients = []
@recipes = get_recipe
#binding.pry
  @recipes.each do |recipe|
    @ingredients << recipe["ingname"]
#binding.pry
  end
  # @ingredients = get_ingredients
  erb :'/recipes/show'
end
