defmodule Exvk.VK.Friends do
  use HTTPotion.Base

  def process_url(url) do
    "https://api.vk.com/method/" <> url
  end

  def process_response_body(body) do
    {:ok, body} = JSEX.decode to_string(body)
    body
  end

  def get_online(query // []) do
    method = "friends.getOnline"
    parsed = URI.parse(method)
    get(to_string(parsed.query(URI.encode_query(query))))
      .body["response"]
  end

end