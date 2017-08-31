# Reset
account = Ptr.Repo.get_by(Ptr.Accounts.Account, db_prefix: "test_account")

if account, do: {:ok, _} = Ptr.Accounts.delete_account(account)

# Create

{:ok, _} = Ptr.Accounts.create_account(%{
  name:      "Test account",
  db_prefix: "test_account"
})
