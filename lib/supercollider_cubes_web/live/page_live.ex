defmodule SupercolliderCubesWeb.PageLive do
  use SupercolliderCubesWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    manifest_path =
      SupercolliderCubes.AudioPipeline.manifest_path(SupercolliderCubes.AudioPipeline)
      |> Path.split()
      |> Enum.reject(fn piece ->
        ["priv", "static"] |> Enum.member?(piece)
      end)
      |> Path.join()

    {:ok,
     assign(
       socket,
       manifest_path: manifest_path,
       muted: true,
       audio_player_loaded: false
     )}
  end

  @impl true
  def handle_event("stop-audio", _value, socket) do
    {:noreply, push_event(assign(socket, muted: true), "stopped-audio", %{})}
  end

  @impl true
  def handle_event("start-audio", _value, socket) do
    {:noreply, push_event(assign(socket, muted: false), "started-audio", %{})}
  end

  @impl true
  def handle_event("audio-player-loaded", _value, socket) do
    {:noreply, assign(socket, audio_player_loaded: true)}
  end

  @impl true
  def handle_event("client-audio-update", %{"pos_x" => pos_x, "pos_y" => pos_y}, socket) do
    SupercolliderCubes.ScSynth.send_command(
      SupercolliderCubes.ScSynth,
      "~synth.set(\"freq\", #{pos_x});"
    )

    {:noreply, socket}
  end
end
