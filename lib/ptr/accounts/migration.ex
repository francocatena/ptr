defmodule Ptr.Accounts.Migration do
  import Ecto.Query

  alias Ptr.Repo
  alias Ptr.Accounts.Account

  @doc """
  Returns a `List` of all account prefixes.

  ## Examples

      iex> account_prefixes()
      ["t_one", ...]

  """
  def account_prefixes do
    Repo.all(from a in Account, select: a.db_prefix)
    |> Enum.map(&("t_#{&1}"))
  end
end
