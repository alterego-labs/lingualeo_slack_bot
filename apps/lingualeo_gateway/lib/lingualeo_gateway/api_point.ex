defmodule LingualeoGateway.ApiPoint do
  @moduledoc """
  Provides an interface for calling LinguaLeo APIs.

  This module is a worker, so you must to start it manually or
  add to the supervisor tree (is a recommended way).
  """

  use GenServer

  @doc """
  Starts a worker
  """
  def start_link(opts \\ []) do
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
  def sign_in(email, password) do
    GenServer.call __MODULE__, {:sign_in, email, password}  
  end

  def handle_call({:sign_in, email, password}, _from, state) do
    result = LingualeoGateway.Methods.SignIn.call(email, password)
    {:reply, result, state}
  end
end
