defmodule OffBroadway.FilesystemWatcher do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args)
  end

  @impl true
  def init(opts) do
    dir = opts[:dir]
    # @TODO: this needs to be made more robust
    name = :"watcher_for_#{dir}"

    case FileSystem.start_link(dirs: [dir], name: name) do
      {:error, message} ->
        raise ArgumentError, "invalid options given, " <> message

      {:ok, watcher_pid} ->
        FileSystem.subscribe(name)

        {:ok,
         %{
           watcher_pid: watcher_pid,
           messages: []
         }}
    end
  end

  @spec get_messages(pid(), integer()) :: list()
  def get_messages(watcher_pid, demand) do
    GenServer.call(watcher_pid, {:get_messages, demand})
  end

  @impl true
  def handle_call({:get_messages, count}, _from, %{messages: messages} = state) do
    {taking, keeping} = Enum.split(messages, count)
    {:reply, taking, %{state | messages: keeping}}
  end

  @impl true
  def handle_info(
        {:file_event, watcher_pid, {path, events}},
        %{watcher_pid: watcher_pid, messages: current_messages} = state
      ) do
    # YOUR OWN LOGIC FOR PATH AND EVENTS
    new_messages = Enum.map(events, fn event -> {path, event} end)
    messages = current_messages ++ new_messages
    {:noreply, %{state | messages: messages}}
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid} = state) do
    {:noreply, state}
  end
end
