defmodule Ptr.Cellars.Vessel do
  use Ecto.Schema

  import Ecto.Changeset
  import Ptr.Accounts.Account, only: [prefix: 1]

  alias Ptr.Cellars.{Cellar, Vessel}
  alias Ptr.Accounts.Account
  alias Ptr.Lots.Part

  schema "vessels" do
    field(:identifier, :string)
    field(:capacity, :decimal)
    field(:material, :string)
    field(:cooling, :string)
    field(:notes, :string)
    field(:lock_version, :integer, default: 1)

    field(:usage, :decimal, default: Decimal.new(0), virtual: true)

    belongs_to(:cellar, Cellar)

    has_many(:parts, Part)

    timestamps()
  end

  @fields [
    :identifier,
    :capacity,
    :material,
    :cooling,
    :notes,
    :cellar_id,
    :lock_version
  ]

  @doc false
  def changeset(%Account{} = account, %Vessel{} = vessel, attrs) do
    prefix_opts = [prefix: prefix(account)]

    vessel
    |> cast(attrs, @fields)
    |> validate_required([:identifier, :capacity, :cellar_id])
    |> validate_length(:identifier, max: 255)
    |> validate_length(:material, max: 255)
    |> validate_length(:cooling, max: 255)
    |> validate_number(:capacity, greater_than: 0, less_than: 1_000_000)
    |> validate_overflow(:capacity)
    |> unsafe_validate_unique([:identifier, :cellar_id], Ptr.Repo, prefix_opts)
    |> unique_constraint(:identifier, name: :vessels_identifier_cellar_id_index)
    |> optimistic_lock(:lock_version)
  end

  def calculate_usage(%Vessel{parts: parts} = vessel) do
    usage =
      parts
      |> Enum.map(& &1.amount)
      |> Enum.reduce(Decimal.new(0), &Decimal.add(&1, &2))

    %{vessel | usage: usage}
  end

  defp validate_overflow(%{data: %{usage: usage}, changes: %{capacity: _}} = changeset, field) do
    validate_change(changeset, field, fn _, capacity ->
      if Decimal.cmp(usage, capacity) == :gt do
        number = usage |> Decimal.round() |> Decimal.to_string()

        [{field, {"must be greater than or equal to %{number}", number: number}}]
      else
        []
      end
    end)
  end

  defp validate_overflow(changeset, _field), do: changeset
end
