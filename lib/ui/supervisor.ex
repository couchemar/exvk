defmodule Exvk.UI.Supervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link({:local, __MODULE__}, __MODULE__, [])
  end

  def init([]) do
    children = [
        worker(Exvk.UI.Worker, [])
    ]
    supervise(children, strategy: :one_for_one)
  end

end