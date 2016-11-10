defmodule SlackBot.API do
  @moduledoc """
  Provides a public API of the SlackBot application 
  """

  @doc """
  Sends a message with a given body and to a given channel which is specifies by its name or ID
  """
  @spec send_message(String.t, String.t) :: none
  def send_message(message_body, channel_identifier) do
    send rtm_process_pid, {:message, message_body, channel_identifier}  
  end

  @doc """
  Seeks and returns for SlackRtm process PID
  """
  @spec rtm_process_pid :: pid
  def rtm_process_pid do
    detect_child_pid(SlackBot.SlackRtm)
  end

  defp detect_child_pid(child_module) do
    worker_spec = SlackBot.Supervisor
                  |> Supervisor.which_children
                  |> Enum.find(fn({module, _pid, _type, _opts}) ->
                    module == child_module
                  end)
    case worker_spec do
      {_module, pid, _type, _opts} ->
        pid
      _ -> nil
    end
  end
end
