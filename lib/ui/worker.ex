defmodule Exvk.UI.Worker do
  use ExActor, export: :ui

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

  defcast init_callbacks, state: frame do
    :error_logger.info_msg "Initializing callbacks"
    :error_logger.info_msg "Frame: #{inspect frame}"
    :ok
  end

end