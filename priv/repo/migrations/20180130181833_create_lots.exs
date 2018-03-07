defmodule Ptr.Repo.Migrations.CreateLots do
  use Ptr, :migration

  def change do
    if prefix = prefix() do
      do_change(prefix)
    else
      for prefix <- account_prefixes(), do: do_change(prefix)
    end
  end

  defp do_change(prefix) do
    create table(:lots, prefix: prefix) do
      add(:identifier, :string, null: false)
      add(:notes, :text)
      add(:owner_id, references(:owners, on_delete: :restrict), null: false)
      add(:variety_id, references(:varieties, on_delete: :restrict), null: false)
      add(:lock_version, :integer, default: 1, null: false)

      timestamps()
    end

    create(unique_index(:lots, [:identifier], prefix: prefix))
    create(index(:lots, [:owner_id], prefix: prefix))
    create(index(:lots, [:variety_id], prefix: prefix))
  end
end
