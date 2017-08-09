ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Ptr.Repo, :manual)

# Ignore migration modules being reloaded.
# See https://github.com/Dania02525/apartmentex/issues/12
Code.compiler_options(ignore_module_conflict: true)
