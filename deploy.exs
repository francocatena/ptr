defmodule Ptr.DeployCallbacks do
  import Gatling.Bash

  def before_mix_digest(env) do
    bash("mkdir", ~w[-p priv/static], cd: env.build_dir)
    bash("yarn",  ~w[install],        cd: "#{env.build_dir}/assets")
    bash("yarn",  ~w[run build],      cd: "#{env.build_dir}/assets")
  end
end
