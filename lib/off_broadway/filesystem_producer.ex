defmodule OffBroadway.FilesystemProducer do
  use GenStage

  def start_link(args) do
    GenStage.start_link(__MODULE__, args)
  end

  @impl true
  def init(opts) do
    dirs = opts[:dirs] || [opts[:dir]]
    # @TODO: this needs to be made more robust
    # @TODO: allow restarting the monitor for new paths
    name = __MODULE__.Watcher

    case FileSystem.start_link(dirs: dirs, name: name) do
      {:error, message} ->
        raise ArgumentError, "invalid options given, " <> message

      {:ok, watcher_pid} ->
        FileSystem.subscribe(name)

        {:producer,
         %{
           watcher_pid: watcher_pid,
           messages: []
         }}
    end
  end

  @impl true
  def handle_demand(demand, %{messages: messages} = state) do
    {taking, keeping} = Enum.split(messages, demand)
    {:noreply, taking, %{state | messages: keeping}}
  end

  @impl true
  @spec handle_info({:file_event, any, :stop | {any, any}}, %{watcher_pid: any}) ::
          {:noreply, %{watcher_pid: any}} | {:noreply, [any], %{messages: any, watcher_pid: any}}
  def handle_info(
        {:file_event, watcher_pid, {path, events}},
        %{watcher_pid: watcher_pid, messages: current_messages} = state
      ) do
    with [message | new_messages] <- Enum.map(events, fn event -> {path, event} end) do
      messages = current_messages ++ new_messages
      {:noreply, [message], %{state | messages: messages}}
    else
      _ -> {:noreply, [], state}
    end
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid} = state) do
    {:noreply, state}
  end
end
