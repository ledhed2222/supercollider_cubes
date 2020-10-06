defmodule SupercolliderCubes.Supervisor do
  use Supervisor

  # Client

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl true
  def init(:ok) do
    children = [
      %{
        id: SupercolliderCubes.ScSynth,
        start: {SupercolliderCubes.ScSynth, :start_link, []},
      },
      %{
        id: SupercolliderCubes.AudioPipeline,
        start: {SupercolliderCubes.AudioPipeline, :start_link, []},
      },
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
