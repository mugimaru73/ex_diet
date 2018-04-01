defmodule ExDiet.Food.Loaders.Meal do
  @moduledoc false

  def data do
    Dataloader.Ecto.new(ExDiet.Repo, query: &query/2)
  end

  def query(queryable, _args) do
    queryable
  end
end
