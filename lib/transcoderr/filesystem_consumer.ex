defmodule Transcoderr.FilesystemConsumer do
  use Broadway

  require Logger

  alias Broadway.Message

  alias Transcoderr.Libraries

  def start_link(opts) do
    dirs = if opts[:dirs] == [], do: ["/nonexistent"], else: opts[:dirs]

    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {OffBroadway.FilesystemProducer, [dirs: dirs]},
        rate_limiting: [
          allowed_messages: 60,
          interval: 10_000
        ]
      ],
      processors: [
        default: [concurrency: 4]
      ],
      batchers: [
        default: [concurrency: 4, batch_size: 16]
      ]
    )
  end

  @spec start(any) :: :ignore | {:error, any} | {:ok, pid} | {:ok, pid, any}
  def start(opts) do
    DynamicSupervisor.start_child(Transcoderr.FilesystemSupervisor, {__MODULE__, opts})
  end

  @spec stop :: :not_found | :ok | {:error, :not_found}
  def stop() do
    case Process.whereis(Transcoderr.FilesystemConsumer) do
      nil ->
        :not_found

      pid ->
        DynamicSupervisor.terminate_child(
          Transcoderr.FilesystemSupervisor,
          pid
        )
    end
  end

  @impl true
  def handle_message(:default, message, _context), do: Message.put_batcher(message, :default)

  @impl true
  def handle_batch(:default, messages, _batch_info, _context) do
    Enum.map(messages, fn message ->
      Message.update_data(message, &handle_fsevent/1)
    end)
  end

  def scan_path(path) do
    producer = Broadway.producer_names(__MODULE__) |> Enum.random()

    Process.send(producer, {:file_event, self(), {path, [:created]}}, [])
  end

  defp handle_fsevent({path, event}) when event in [:created, :inodemetamod] do
    Libraries.create_or_update_medium_by_path!(path)
  end

  defp handle_fsevent({path, event}) when event in [:removed] do
    case Libraries.delete_media_by_path(path) do
      {count, _} when count > 0 ->
        Logger.info("Deleted media for #{inspect(path)}", path: path)

      {0, _} ->
        Logger.info("Could not find any media to delete for #{inspect(path)}", path: path)
    end
  end

  # @TODO we should debounce these during batching
  defp handle_fsevent({_path, event}) when event in [:changeowner, :xattrmod], do: :skipped

  defp handle_fsevent({path, event}) do
    IO.inspect(path, label: "path")
    IO.inspect(event, label: "event")
  end
end
