defmodule Ptr.Repo.Migrations.CreateVessels do
  use Ptr, :migration

  def change do
    if prefix = prefix() do
      do_change(prefix)
    else
      for prefix <- account_prefixes(), do: do_change(prefix)
    end
  end

  defp do_change(prefix) do
    create table(:vessels, prefix: prefix) do
      add(:identifier, :string, null: false)
      add(:capacity, :decimal, null: false, precision: 10, scale: 4)
      add(:material, :string)
      add(:cooling, :string)
      add(:notes, :text)
      add(:cellar_id, references(:cellars, on_delete: :delete_all))
      add(:lock_version, :integer, default: 1, null: false)

      timestamps()
    end

    create(unique_index(:vessels, :identifier, prefix: prefix))
    create(index(:vessels, :cellar_id, prefix: prefix))
  end
end
