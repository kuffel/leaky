defmodule Leaky do
  @moduledoc """
  Documentation for `Leaky`.
  """
  require Logger

  def demo() do
    Enum.each(1..1_000, fn(_i) ->
      run_os_cmd("sleep 2 && ls")
    end)
  end

  def run_os_cmd(cmd) do
    spawn fn ->
      :exec.run(cmd, [:stdin, :stdout, :stderr, :monitor])

      receive do
        {:stdout, _os_pid, result} ->
          Logger.info("#{result}")

        {:DOWN, _os_pid, :process, _port, reason} ->
          Logger.info("Finished #{inspect cmd} with reason: #{inspect reason}")


        ret ->
          IO.inspect ret
      after
        60_000 ->
          Logger.error("Timeout calling: #{inspect cmd}")
      end
    end
  end
end
