defmodule ExDiet.Repo.Migrations.CreateAuthTokens do
  use Ecto.Migration

  def change do
    create table(:auth_tokens, primary_key: false) do
      add(:jti, :string, primary_key: true)
      add(:aud, :string, primary_key: true)
      add(:typ, :string)
      add(:iss, :string)
      add(:sub, :string)
      add(:exp, :bigint)
      add(:jwt, :text)
      add(:claims, :json)
      timestamps(type: :utc_datetime)
    end
  end
end
