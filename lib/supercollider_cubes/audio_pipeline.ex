defmodule SupercolliderCubes.AudioPipeline do
  use GenServer

  # Client

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def manifest_path(pid) do
    GenServer.call(pid, {:manifest_path})
  end

  # Server
  
  @impl true
  def init(:ok) do
    manifest_path = output_path()
    {:ok, pid} = SupercolliderCubes.AudioPipeline.Pipeline.start_link(%{
      output_path: manifest_path,
    })
    Membrane.Pipeline.play(pid)
    {:ok, %{
      pipeline_pid: pid,
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
end
