defmodule SupercolliderCubes.AudioPipeline do
  use GenServer

  # Client

  def start_link(recording_path) do
    GenServer.start_link(__MODULE__, {:ok, recording_path}, name: __MODULE__)
  end

  def manifest_path(pid) do
    GenServer.call(pid, {:manifest_path})
  end

  # Server
  
  @impl true
  def init({:ok, recording_path}) do
    manifest_path = output_path()
    {:ok, pid} = SupercolliderCubes.AudioPipeline.Pipeline.start_link({
      recording_path,
      manifest_path,
    })
    wait_for_input(recording_path, fn ->
      Membrane.Pipeline.play(pid)
    end)
    {:ok, %{
      pipeline_pid: pid,
      recording_path: recording_path,
      manifest_path: manifest_path <> ".m3u8",
    }}
  end

  @impl true
  def handle_call({:manifest_path}, _from, state) do
    {:reply, Map.get(state, :manifest_path), state}
  end

  defp output_path do
    Path.join("priv/static/audio", Integer.to_string(:rand.uniform(4294967296), 32))
  end

  defp wait_for_input(recording_path, then) do
    case recording_path |> File.exists? do
      true ->
        then.()
      false ->
        Process.sleep(250)
        wait_for_input(recording_path, then)
    end
  end
end
