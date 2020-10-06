defmodule SupercolliderCubesWeb.ScChannel do
  use Phoenix.Channel

  def join("sc:" <> _anything, _message, socket) do
    {:ok, socket}
  end
end
