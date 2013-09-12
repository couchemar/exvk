defmodule Exvk.UI.Worker do
  use ExActor, export: :ui

  defrecord WX, Record.extract(:wx, from_lib: "wx/include/wx.hrl")

  definit do
    wx = :wx.new()
    xrc = :wxXmlResource.get()
    :ok = :wxXmlResource.initAllHandlers(xrc)
    true = :wxXmlResource.load(xrc, 'gui/exvk.xrc')
    top_frame = :wxFrame.new()
    :wxXmlResource.loadFrame(xrc, top_frame, wx, 'MainFrame')
    true = :wxFrame.show(top_frame)
    init_callbacks()
    top_frame
  end

  defcast init_callbacks, state: state do
    :error_logger.info_msg "Initializing callbacks"
    :error_logger.info_msg "State: #{inspect state}"
    :wxFrame.connect(state, :command_menu_selected)
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