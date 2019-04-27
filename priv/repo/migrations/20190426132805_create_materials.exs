defmodule Ptr.Repo.Migrations.CreateMaterials do
  use Ptr, :migration

  def change do
    if prefix = prefix() do
      do_change(prefix)
    else
      for prefix <- account_prefixes(), do: do_change(prefix)
    end
  end

  defp do_change(prefix) do
    create table(:materials, prefix: prefix) do
      add(:name, :string)
      add(:lock_version, :integer, default: 1, null: false)

      timestamps()
    end

    create(unique_index(:materials, [:name], prefix: prefix))
  end
end
