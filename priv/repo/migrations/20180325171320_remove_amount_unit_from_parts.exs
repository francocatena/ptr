defmodule Ptr.Repo.Migrations.RemoveAmountUnitFromParts do
  use Ptr, :migration

  def change do
    if prefix = prefix() do
      do_change(prefix)
    else
      for prefix <- account_prefixes(), do: do_change(prefix)
    end
  end

  defp do_change(prefix) do
    alter table(:parts, prefix: prefix) do
      remove(:amount_unit)
    end
  end
end
