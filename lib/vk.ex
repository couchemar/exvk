defmodule Exvk.VK.Friends do
  use HTTPotion.Base

  def process_url(url) do
    "https://api.vk.com/method/friends." <> url
  end

  def process_response_body(body) do
    {:ok, body} = JSEX.decode to_string(body)
    body
  end

  def api_get_online(query // []) do
    method = "getOnline"
    parsed = URI.parse(method)
    get(to_string(parsed.query(URI.encode_query(query))))
      .body["response"]
  end
end

defmodule Exvk.VK.Users do
  use HTTPotion.Base

  def process_url(url) do
    "https://api.vk.com/method/users." <> url
  end

  def process_response_body(body) do
    {:ok, body} = JSEX.decode to_string(body)
    body
  end

  def api_get(query // []) do
    method = "get"
    parsed = URI.parse(method)
    body = get(to_string(parsed.query(URI.encode_query(query)))).body["response"]
    lc el inlist body do
      el = ListDict.put(el, "first_name",
                   :unicode.characters_to_binary(el["first_name"], :utf8, :latin1))
      ListDict.put(el, "last_name",
                   :unicode.characters_to_binary(el["last_name"], :utf8, :latin1))
    end
  end
end

defmodule Exvk.VK.Messages do
  use HTTPotion.Base

  def process_url(url) do
    "https://api.vk.com/method/messages." <> url
  end

  def process_response_body(body) do
    {:ok, body} = JSEX.decode to_string(body)
    body
  end

  def api_get_history(query // []) do
    method = "getHistory"
    parsed = URI.parse(method)
    body = get(to_string(parsed.query(URI.encode_query(query)))).body["response"]

    items = body["items"]

    items = lc item inlist items do
      ListDict.put(item, "body",
                   :unicode.characters_to_binary(item["body"], :utf8, :latin1))
    end
    ListDict.put(body, "items", items)
  end

end