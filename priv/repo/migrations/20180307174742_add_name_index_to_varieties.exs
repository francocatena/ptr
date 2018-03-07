defmodule Ptr.Repo.Migrations.AddNameIndexToVarieties do
  use Ptr, :migration

  def change do
    if prefix = prefix() do
      do_change(prefix)
    else
      for prefix <- account_prefixes(), do: do_change(prefix)
    end
  end

  defp do_change(prefix) do
    create(index(:varieties, :name, prefix: prefix))
  end
end
