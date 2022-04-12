defmodule OffBroadway.FilesystemProducer do
  use GenStage

  alias Broadway.Message

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
           messages: :queue.new(),
           pending_demand: 0
         }}
    end
  end

  @impl true
  def handle_demand(incoming_demand, %{messages: queue, pending_demand: pending_demand} = state) do
    {events, queue, demand} = dispatch_events(queue, incoming_demand + pending_demand, [])
    {:noreply, events, %{state | messages: queue, pending_demand: demand}}
  end

  @impl true
  def handle_info(
        {:file_event, _watcher_pid, {path, events}},
        %{messages: queue, pending_demand: pending_demand} = state
      ) do
    queue =
      Enum.reduce(events, queue, fn event, acc ->
        msg = %Message{data: {path, event}, acknowledger: {__MODULE__, :ack_id, :ack_data}}
        :queue.in(msg, acc)
      end)

    {events, queue, pending_demand} = dispatch_events(queue, pending_demand, [])

    {:noreply, events, %{state | messages: queue, pending_demand: pending_demand}}
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid} = state) do
    {:noreply, state}
  end

  # always just drop the event
  def ack(:ack_id, _successful, _failed) do
    :ok
  end

  defp dispatch_events(queue, 0, events), do: {Enum.reverse(events), queue, 0}

  defp dispatch_events(queue, demand, events) do
    case :queue.out(queue) do
      {{:value, event}, queue} ->
        # we got one event, recurse to get more unless demand is met
        dispatch_events(queue, demand - 1, [event | events])

      {:empty, queue} ->
        # we ran out of events and there is still demand for more
        {Enum.reverse(events), queue, demand}
    end
  end
end
