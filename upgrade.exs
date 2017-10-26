defmodule Ptr.UpgradeCallbacks do
  import Gatling.Bash

  def before_mix_digest(env) do
    bash("yarn", ~w[install],   cd: "#{env.build_dir}/assets")
    bash("yarn", ~w[run build], cd: "#{env.build_dir}/assets")
  end

  def before_upgrade_service(env) do
    bash("mix", ~w[ecto.migrate], cd: env.build_dir)
  end
end
