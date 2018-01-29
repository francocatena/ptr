defmodule Ptr.Repo.Migrations.ChangeVesselIdentifierUniqueIndex do
  use Ptr, :migration

  def change do
    if prefix = prefix() do
      do_change(prefix)
    else
      for prefix <- account_prefixes(), do: do_change(prefix)
    end
  end

  defp do_change(prefix) do
    drop(unique_index(:vessels, :identifier, prefix: prefix))
    create(unique_index(:vessels, [:identifier, :cellar_id], prefix: prefix))
  end
end
