defmodule LingualeoGateway.ApiPoint do
  @moduledoc """
  Provides an worker process for calling LinguaLeo APIs.

  This module is a worker, so you must to start it manually or
  add to the supervisor tree (is a recommended way).
  """

  use GenServer

  alias LingualeoGateway.Methods.{SignIn, GetUserdict}

  @type reason :: Atom.t

  @doc """
  Starts a worker
  """
  def start_link(_opts \\ []) do
    GenServer.start_link __MODULE__, :ok, name: __MODULE__
  end

  @doc """
  Callack of initialization process
  """
  def init(:ok) do
    {:ok, 0}
  end

  @doc """
  Sends sign in request to the LinguaLeo API
  """
  @spec sign_in(String.t, String.t) :: {:ok | :error, String.t, Map.t, [String.t]}
  def sign_in(email, password) do
    GenServer.call __MODULE__, {:sign_in, email, password}  
  end

  @doc """
  Gets user's dictionary list
  """
  @spec get_userdict(list(String.t), pos_integer) :: {:ok, UserDict.t} | {:error, reason}
  def get_userdict(cookies, offset) do
    GenServer.call __MODULE__, {:get_userdict, cookies, offset} 
  end

  def handle_call({:sign_in, email, password}, _from, state) do
    result = SignIn.call(email, password)
    {:reply, result, state}
  end
  def handle_call({:get_userdict, cookies, offset}, _from, state) do
    result = GetUserdict.call(cookies, offset)
    {:reply, result, state}
  end
end
