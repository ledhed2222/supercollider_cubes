defmodule SupercolliderCubes.ScSynth do
  use GenServer
  require Logger

  @command "bin/supercollider_start.sh"

  # Client

  def start_link(recording_path) do
    result = GenServer.start_link(__MODULE__, {:ok, recording_path}, name: __MODULE__)
    case result do
      {:ok, pid} ->
        send_command(pid, initialize_sc(recording_path))
        {:ok, pid}
      {:error, {:already_started, pid}} ->
        {:ok, pid}
    end
  end

  def send_command(pid, commands) when is_bitstring(commands) do
    GenServer.cast(pid, {:send_command, sanitize(commands)})
  end

  def send_command(pid, commands) when is_list(commands) do
    commands |> Enum.map(fn(command) -> send_command(pid, command) end)
  end

  defp sanitize(command) do
    command |>
      String.replace(~r/\/\/.*\n/, "") |>
      String.replace(~r/[\n\r\x{001c}]/, "")
  end

  defp initialize_sc(recording_path) do
    Path.join([__DIR__, "sc_synth", "initialize_sc.scd.eex"]) |>
      EEx.eval_file(recording_path: recording_path)
  end

  # Server

  @impl true
  def init({:ok, recording_path}) do
    port = Port.open({:spawn, @command}, [:binary, :exit_status])
    Port.monitor(port)
    {:ok, %{
      recording_path: recording_path,
      port: port,
      latest_output: nil,
      exit_status: nil,
    }}
  end

  @impl true
  def handle_cast({:send_command, command}, state) do
    Map.get(state, :port) |> Port.command(command <> "\u000a")
    {:noreply, state}
  end

  @impl true
  def handle_info({_port, {:data, text_line}}, state) do
    latest_output = text_line |> String.trim
    Logger.info "#{__MODULE__} latest output: #{latest_output}\n"
    {:noreply, %{state | latest_output: latest_output}}
  end

  @impl true
  def handle_info({_port, {:exit_status, status}}, state) do
    Logger.error "#{__MODULE__} external exit: exit_status: #{status}"
    {:noreply, %{state | exit_status: status}}
  end

  @impl true
  def handle_info({:DOWN, _ref, :port, port, :normal}, state) do
    Logger.error "Handled :DOWN message from port: #{port}"
    {:noreply, state}
  end

  @impl true
  def handle_info(msg, state) do
    Logger.error "Unhandled message: #{msg}"
    {:noreply, state}
  end
end
