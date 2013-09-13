defmodule Exvk.UI.Supervisor do
  use Supervisor.Behaviour

  def start_link(access_token) do
    :supervisor.start_link({:local, __MODULE__}, __MODULE__, [access_token])
  end

  def init([access_token]) do
    children = [
        worker(Exvk.UI.Worker, [access_token])
    ]
    supervise(children, strategy: :one_for_one)
  end

end