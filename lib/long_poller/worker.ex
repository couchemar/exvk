defmodule Exvk.LongPoller.Worker do
  use ExActor, export: :lpw

  definit access_token do
    resp = Exvk.VK.Messages.api_get_long_poll_server access_token
    fetch(resp["server"], resp["key"], resp["ts"])
    :ok
  end

  defcast fetch(server, key, ts) do
    :error_logger.info_msg "Fetching (#{server}, #{key}, #{ts})"
    ts_new = Exvk.VK.LongPoll.get(server, key, ts) |> process_resp
    fetch(server, key, ts_new || ts)
    :ok
  end

  def process_resp(resp) do
    :error_logger.info_msg "Got resp: #{inspect resp}"
    if resp["failed"] == 2 do
      :error_logger.warning_msg "Long Poll key expired. Restart"
      exit(:normal)
    end
    resp["ts"]
  end

end