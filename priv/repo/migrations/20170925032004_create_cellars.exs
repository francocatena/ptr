defmodule Ptr.Repo.Migrations.CreateCellars do
  use Ptr, :migration

  def change do
    if prefix = prefix() do
      do_change(prefix)
    else
      for prefix <- account_prefixes(), do: do_change(prefix)
    end
  end

  defp do_change(prefix) do
    create table(:cellars, prefix: prefix) do
      add :identifier, :string
      add :name, :string
      add :lock_version, :integer, default: 1, null: false

      timestamps()
    end

    create unique_index(:cellars, :identifier, prefix: prefix)
  end
end
