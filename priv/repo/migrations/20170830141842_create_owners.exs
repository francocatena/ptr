defmodule Ptr.Repo.Migrations.CreateOwners do
  use Ptr, :migration

  def change do
    if prefix = prefix() do
      do_change(prefix)
    else
      for prefix <- account_prefixes(), do: do_change(prefix)
    end
  end

  defp do_change(prefix) do
    create table(:owners, prefix: prefix) do
      add(:name, :string, null: false)
      add(:tax_id, :string, null: false)
      add(:lock_version, :integer, default: 1, null: false)

      timestamps()
    end

    create(unique_index(:owners, :tax_id, prefix: prefix))
  end
end
