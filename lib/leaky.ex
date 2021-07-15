defmodule Leaky do
  @moduledoc """
  Documentation for `Leaky`.
  """
  require Logger

  def demo() do
    Enum.each(1..1_000, fn i ->
      run_os_cmd("sleep 2", i)
    end)
  end

  def run_os_cmd(cmd, i) do
    spawn(fn ->
      :exec.run(cmd, [:stdin, :stdout, :stderr, :monitor])

      receive do
        {:stdout, _os_pid, result} ->
          Logger.info("#{i}: #{result}")

        {:DOWN, _os_pid, :process, _port, reason} ->
          Logger.info("#{i}: Finished #{inspect(cmd)} with reason: #{inspect(reason)}")

        other ->
          Logger.warn("#{i}: Unmatched reply: #{inspect(other)}")
      after
        60_000 ->
          Logger.error("#{i}: Timeout calling: #{inspect(cmd)}")
      end
    end)
  end
end
