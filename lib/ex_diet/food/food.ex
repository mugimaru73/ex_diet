defmodule ExDiet.Food do
  @moduledoc """
  The Food context.
  """

  import Ecto.Query, warn: false
  alias ExDiet.Repo

  alias ExDiet.Food.{Recipe, Ingredient, Calendar, Meal}

  def create_ingredient(attrs \\ %{}) do
    %Ingredient{}
    |> Ingredient.changeset(attrs)
    |> Repo.insert()
  end

  def update_ingredient(%Ingredient{} = ingredient, attrs) do
    ingredient
    |> Ingredient.changeset(attrs)
    |> Repo.update()
  end

  def delete_ingredient(%Ingredient{} = ingredient) do
    case count_references(ingredient) do
      0 ->
        Repo.delete(ingredient)

      _ ->
        {:error, :referenced}
    end
  end

  def create_recipe(attrs \\ %{}) do
    %Recipe{}
    |> Recipe.changeset(attrs)
    |> Repo.insert()
  end

  def update_recipe(%Recipe{} = recipe, attrs) do
    recipe
    |> Recipe.changeset(attrs)
    |> Repo.update()
  end

  def delete_recipe(%Recipe{} = recipe) do
    case count_references(recipe) do
      0 ->
        Repo.delete(recipe)

      _ ->
        {:error, :referenced}
    end
  end

  def create_calendar(attrs) do
    %Calendar{}
    |> Calendar.changeset(attrs)
    |> Repo.insert()
  end

  def update_calendar(%Calendar{} = calendar, attrs) do
    {:ok, res} =
      Repo.transaction(fn ->
        Repo.delete_all(from(m in Meal, where: m.calendar_id == ^calendar.id))

        calendar
        |> Repo.preload(meals: [:recipe, :ingredient])
        |> Calendar.changeset(attrs)
        |> Repo.update()
      end)

    res
  end

  defp count_references(%Ingredient{} = entity), do: count_references(entity, [:meals, :recipe_ingredients])
  defp count_references(%Recipe{} = entity), do: count_references(entity, [:meals])

  defp count_references(entity, assocs) do
    Enum.reduce(assocs, 0, fn assoc, acc ->
      acc +
        Repo.one(
          from(q in entity.__struct__, join: a in assoc(q, ^assoc), where: q.id == ^entity.id, select: count(a.id))
        )
    end)
  end
end
