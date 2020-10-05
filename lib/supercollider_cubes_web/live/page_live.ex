defmodule SupercolliderCubesWeb.PageLive do
  use SupercolliderCubesWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    manifest_path = SupercolliderCubes.AudioPipeline.manifest_path(SupercolliderCubes.AudioPipeline) |> Path.split |> Enum.reject(fn piece ->
      ["priv", "static"] |> Enum.member?(piece)
    end) |> Path.join
    {:ok, assign(
      socket,
      :manifest_path, manifest_path
    )}
  end

  @impl true
  def handle_event("stop-audio", _value, socket) do
    ## TODO: can this be encapsulated
    SupercolliderCubes.ScSynth.send_command(
      SupercolliderCubes.ScSynth,
      """
      ~synth.free;
      s.stopRecording;
      """
    )
    {:noreply, socket}
  end
end
