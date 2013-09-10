defmodule Exvk.LongPoller.Worker do
  use ExActor, export: :singleton

  definit access_token do
    resp = Exvk.VK.Messages.api_get_long_poll_server access_token
    fetch(resp["server"], resp["key"], resp["ts"])
  end

  defcast fetch(server, key, ts) do
    :error_logger.info_msg "Fetching (#{server}, #{key}, #{ts})"
    resp = Exvk.VK.LongPoll.get server, key, ts
    :error_logger.info_msg "Got resp: #{inspect resp}"
    fetch(server, key, resp["ts"] || ts)
    :ok
  end

end