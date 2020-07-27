defmodule OffBroadway.FilesystemProducer do
  use GenStage

  require Logger
  @impl true
  def init(opts) do
    dir = opts[:dir]
    # @TODO: this needs to be made more robust
    name = String.to_atom("#{dir}_monitor")

    case FileSystem.start_link(dirs: [dir], name: name) do
      {:error, message} ->
        raise ArgumentError, "invalid options given, " <> message

      {:ok, watcher_pid} ->
        FileSystem.subscribe(name)

        {:producer,
         %{
           demand: 0,
           watcher_pid: watcher_pid,
           messages: []
         }}
    end
  end

  @impl true
  def handle_demand(incoming_demand, %{demand: demand} = state) do
    handle_receive_messages(%{state | demand: demand + incoming_demand})
  end

  def handle_receive_messages(%{demand: demand, messages: messages} = state) when demand > 0 do
    {outgoing, saved} = Enum.split(messages, demand)
    new_demand = demand - length(outgoing)

    {:noreply, outgoing, %{state | demand: new_demand, messages: saved}}
  end

  def handle_receive_messages(state) do
    {:noreply, [], state}
  end

  @impl true
  def handle_info(
        {:file_event, watcher_pid, {path, events}},
        %{watcher_pid: watcher_pid, messages: current_messages} = state
      ) do
    # YOUR OWN LOGIC FOR PATH AND EVENTS
    new_messages = Enum.map(events, fn event -> {path, event} end)
    messages = current_messages ++ new_messages
    IO.inspect()
    {:noreply, %{state | messages: messages}}
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid} = state) do
    {:noreply, state}
  end
end
