defmodule Ptr.Accounts.Migration do
  alias Ptr.Repo
  alias Ptr.Accounts
  alias Ptr.Accounts.Account

  @doc """
  Returns a `List` of all account prefixes.

  ## Examples

      iex> account_prefixes()
      ["t_one", ...]

  """
  def account_prefixes do
    Account
    |> Repo.all()
    |> Enum.map(&Accounts.prefix(&1))
  end
end
