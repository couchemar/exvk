defmodule Exvk.UI.Worker do
  use ExActor, export: :ui

  defrecord WX, Record.extract(:wx, from_lib: "wx/include/wx.hrl")

  defrecord State, access_token: nil,
                   top_frame: nil,
                   friends_list: nil

  definit(access_token) do
    wx = :wx.new()
    xrc = :wxXmlResource.get()
    :ok = :wxXmlResource.initAllHandlers(xrc)
    true = :wxXmlResource.load(xrc, 'gui/exvk.xrc')
    top_frame = :wxFrame.new()
    :wxXmlResource.loadFrame(xrc, top_frame, wx, 'MainFrame')
    true = :wxFrame.show(top_frame)
    init_callbacks()
    initial_data()
    friends_list = :wxXmlResource.xrcctrl(top_frame, 'friendsList', :wxListBox)
    State.new(top_frame: top_frame,
              friends_list: friends_list,
              access_token: access_token)
  end

  defcast init_callbacks, state: State[top_frame: top_frame] = state do
    :error_logger.info_msg "Initializing callbacks"
    :error_logger.info_msg "State: #{inspect state}"
    :wxFrame.connect(top_frame, :command_menu_selected)
    :ok
  end

  defcast initial_data, state: State[access_token: access_token] do
    :error_logger.info_msg "Init loads online friends list"
    spawn(fn() ->
      resp = Exvk.VK.Users.api_get(
        access_token, Exvk.VK.Friends.api_get_online(access_token)
      )
      fill_list(
        lc item inlist resp, do: [
          key: item["first_name"] <> " " <> item["last_name"],
          data: [id: item["id"]]
        ]
)
          end)
    :ok
  end

  defcast fill_list(data), state: State[friends_list: friends_list] do
    lc friend inlist data do
      :wxListBox.append(
        friends_list,
        String.to_char_list!(friend[:key]),
        friend[:data]
      )
    end
    :ok
  end

  definfo {:wx, _, _, _, _} = msg do
    :error_logger.info_msg "Got event: #{inspect msg}"
    [_|tail] = :erlang.tuple_to_list(msg)
    process_ui_event(:erlang.list_to_tuple([WX|tail]))
  end

  definfo msg do
    :error_logger.info_msg "Got unhandled msg: #{inspect msg}"
    :ok
  end

  @menu_exit 101
  def process_ui_event WX[id: @menu_exit, obj: frame] do
    :error_logger.info_msg "Exit pressed"
    :error_logger.info_msg "Frame: #{inspect frame}"
    :wxFrame.close(frame)
    :application.stop(:exvk)
    :ok
  end
end