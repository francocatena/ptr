defmodule Ptr.Repo.Migrations.AddMaterialToVessels do
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
      add(:material_id, references(:materials, on_delete: :restrict))
    end

    create(index(:vessels, [:material_id], prefix: prefix))
  end
end
