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
    parsed = URI.parse("getOnline")
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
    parsed = URI.parse("get")
    body = get(to_string(parsed.query(URI.encode_query(query)))).body["response"]
    lc el inlist body do
      el |> ListDict.put("first_name",
                         :unicode.characters_to_binary(el["first_name"], :utf8, :latin1))
      |> ListDict.put("last_name",
                      :unicode.characters_to_binary(el["last_name"], :utf8, :latin1))
    end
  end
end

defmodule Exvk.VK.Messages do
  use HTTPotion.Base

  @defaults [v: 5.0]

  def process_url(url) do
    "https://api.vk.com/method/messages." <> url
  end

  def process_response_body(body) do
    {:ok, body} = JSEX.decode to_string(body)
    body
  end

  def api_get_history(access_token, user_id, query // []) do
    query = query
    |> Dict.merge(@defaults)
    |> Dict.put(:access_token, access_token)
    |> Dict.put(:user_id, user_id)
    parsed = URI.parse("getHistory")
    body = get(to_string(parsed.query(URI.encode_query(query)))).body["response"]
    ListDict.put(
      body, "items",
      lc item inlist body["items"] do
        ListDict.put(item, "body",
                     :unicode.characters_to_binary(item["body"], :utf8, :latin1))
      end)
  end

  def api_send(access_token, user_id, message, query // []) do
    query = query
    |> Dict.merge(@defaults)
    |> Dict.put(:access_token, access_token)
    |> Dict.put(:user_id, user_id)
    |> Dict.put(:message, message)
    parsed = URI.parse("send")
    get(to_string(parsed.query(URI.encode_query(query)))).body["response"]
  end

  def api_mark_as_read(access_token, sender_id, query // []) do
    query = query
    |> Dict.merge(@defaults)
    |> Dict.put(:access_token, access_token)
    |> Dict.put(:user_id, sender_id)
    parsed = URI.parse("markAsRead")
    get(to_string(parsed.query(URI.encode_query(query)))).body["response"]
  end
end