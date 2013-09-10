defmodule Exvk.Supervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    {:ok, :config} = :dets.open_file(:config, file: "config.dets")
    res = :dets.lookup(:config, :access_token)
    children = [
      supervisor(Exvk.LongPoller.Supervisor, [res[:access_token]])
    ]
    supervise(children, strategy: :one_for_one)
  end
end
