defmodule Transcoderr.FilesystemConsumer do
  use Broadway

  require Logger

  alias Broadway.Message

  def start_link(opts) do
    dirs = opts[:dirs] || ["/nonexistent"]

    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {OffBroadway.FilesystemProducer, [dirs: dirs]},
        transformer: {__MODULE__, :transform, []},
        rate_limiting: [
          allowed_messages: 60,
          interval: 10_000
        ]
      ],
      processors: [
        default: [concurrency: 1]
      ]
    )
  end

  def start(opts) do
    DynamicSupervisor.start_child(Transcoderr.FilesystemSupervisor, {__MODULE__, opts})
  end

  def stop() do
    DynamicSupervisor.terminate_child(
      Transcoderr.FilesystemSupervisor,
      Process.whereis(Transcoderr.FilesystemConsumer)
    )
  end

  @impl true
  def handle_message(:default, %Message{data: {path, event}} = message, _context) do
    handle_fsevent(path, event)

    message
  end

  defp handle_fsevent(path, event) when event in [:created, :modified] do
    medium = Transcoderr.Libraries.get_medium_by_path(path)

    case Transcoderr.Libraries.get_medium_by_path(medium_attrs(path)) do
      {:ok, medium} ->
        Logger.debug("Created medium #{inspect(medium)}", medium_id: medium.id)

      {:error, medium} ->
        Logger.debug("Could not create medium for path #{inspect(path)} (#{inspect(medium)})",
          path: path,
          medium: medium
        )
    end
  end

  defp handle_fsevent(path, event) when event in [:deleted] do
    case Transcoderr.Libraries.delete_media_by_path(path) do
      {count, _} when count > 0 ->
        Logger.debug("Deleted media for #{inspect(path)}", path: path)

      {0, _} ->
        Logger.debug("Could not find any media to delete for #{inspect(path)}", path: path)
    end
  end

  defp handle_fsevent(path, event) do
    IO.inspect(path, label: "path")
    IO.inspect(event, label: "event")
  end

  defp medium_attrs(path) do
    %{
      name: Path.basename(path),
      path: path,
      extension: Path.extname(path),
      video_codec: "hardcoded",
      library_id: Transcoderr.Libraries.get_library_by_path(path).id
    }
  end

  @spec transform(any, any) :: Broadway.Message.t()
  def transform(event, _opts) do
    %Message{
      data: event,
      acknowledger: {__MODULE__, :ack_id, :ack_data}
    }
  end

  def ack(:ack_id, _successful, _failed) do
    :ok
  end
end
