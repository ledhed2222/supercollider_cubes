defmodule SupercolliderCubesWeb.ScChannel do
  use Phoenix.Channel

  def join("sc:" <> _anything, _message, socket) do
    {:ok, socket}
  end

  def handle_in(%{"posX" => pos_x, "posY" => _pos_y}, _any, socket) do
    SupercolliderCubes.ScSynth.send_command(
      SupercolliderCubes.ScSynth,
      "~synth.set(\"freq\", #{pos_x});"
    )
    {:noreply, socket}
  end
end
