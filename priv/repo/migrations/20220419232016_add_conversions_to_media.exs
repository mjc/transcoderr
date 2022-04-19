defmodule Transcoderr.Repo.Migrations.AddConversionsToMedia do
  use Ecto.Migration

  def change do
    alter table("media") do
      add(:conversions, :map)
    end
  end
end
