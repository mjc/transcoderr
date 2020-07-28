defmodule Transcoderr.MediaInfo do
  def run(path) do
    {stdout, _} = System.cmd("mediainfo", ["--Output=JSON", path])
    Jason.decode(stdout)
  end
end
