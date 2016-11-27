defmodule SlackBot.Operations.UpdateDictionary do
  @moduledoc """
  Makes update dictionary operation to the Lingualeo API
  """

  alias SlackBot.Core.{IncomeMessage}

  @doc """
  Calls sign in operation
  """
  @spec call(IncomeMessage.t) :: :ok #| {:error, :invalid_message | :invalid_credentials}
  def call(%IncomeMessage{} = message) do
  end
end
