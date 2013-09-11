defmodule Exvk.UI.Worker do
  use ExActor, export: :ui

  alias :wx, as: WX

  defrecord :wx, Record.extract(:wx, from_lib: "wx/include/wx.hrl")

  definit do
    wx = WX.new()
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

  @menu_exit 101
  definfo :wx[id: @menu_exit, obj: frame] do
    :error_logger.info_msg "Exit pressed"
    :error_logger.info_msg "Frame: #{inspect frame}"
    :wxFrame.close(frame)
    :ok
  end

  definfo :wx[] = msg do
    :error_logger.info_msg "Got unhandled msg: #{inspect msg}"
    :ok
  end

end