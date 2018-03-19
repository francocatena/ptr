defmodule Ptr.Repo.Migrations.CreateParts do
  use Ptr, :migration

  def change do
    if prefix = prefix() do
      do_change(prefix)
    else
      for prefix <- account_prefixes(), do: do_change(prefix)
    end
  end

  defp do_change(prefix) do
    create table(:parts, prefix: prefix) do
      add(:amount, :decimal, precision: 10, scale: 2, null: false)
      add(:amount_unit, :string, default: "l", null: false)
      add(:lot_id, references(:lots, on_delete: :restrict), null: false)
      add(:vessel_id, references(:vessels, on_delete: :restrict), null: false)
      add(:lock_version, :integer, default: 1, null: false)

      timestamps()
    end

    create(index(:parts, [:lot_id], prefix: prefix))
    create(index(:parts, [:vessel_id], prefix: prefix))
  end
end
