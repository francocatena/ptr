defmodule Ptr.Repo.Migrations.AddCellarToLots do
  use Ptr, :migration

  def change do
    if prefix = prefix() do
      do_change(prefix)
    else
      for prefix <- account_prefixes(), do: do_change(prefix)
    end
  end

  defp do_change(prefix) do
    alter table(:lots, prefix: prefix) do
      add(:cellar_id, references(:cellars, on_delete: :restrict), null: false)
    end

    create(index(:lots, [:cellar_id], prefix: prefix))
  end
end
