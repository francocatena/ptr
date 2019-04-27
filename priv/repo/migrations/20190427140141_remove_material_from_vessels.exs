defmodule Ptr.Repo.Migrations.RemoveMaterialFromVessels do
  use Ptr, :migration

  def change do
    if prefix = prefix() do
      do_change(prefix)
    else
      for prefix <- account_prefixes(), do: do_change(prefix)
    end
  end

  defp do_change(prefix) do
    alter table(:vessels, prefix: prefix) do
      remove(:material)
    end
  end
end
