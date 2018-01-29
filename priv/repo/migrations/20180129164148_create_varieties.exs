defmodule Ptr.Repo.Migrations.CreateVarieties do
  use Ptr, :migration

  def change do
    if prefix = prefix() do
      do_change(prefix)
    else
      for prefix <- account_prefixes(), do: do_change(prefix)
    end
  end

  defp do_change(prefix) do
    create table(:varieties, prefix: prefix) do
      add(:identifier, :string, null: false)
      add(:name, :string, null: false)
      add(:clone, :string, null: false)
      add(:lock_version, :integer, default: 1, null: false)

      timestamps()
    end

    create(unique_index(:varieties, [:identifier], prefix: prefix))
  end
end
