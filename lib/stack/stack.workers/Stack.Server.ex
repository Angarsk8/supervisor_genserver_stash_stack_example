defmodule Stack.Server do
  use GenServer

  # Client API implementation

  def start_link(stash_id) do
    GenServer.start_link(__MODULE__, stash_id, name: __MODULE__)
  end

  def pop do
    GenServer.call(__MODULE__, :pop)
  end

  def push(value) do
    GenServer.cast(__MODULE__, {:push, value})
  end

  def get_stack do
    GenServer.call(__MODULE__, :get_stack)
  end

  def shutdown do
    GenServer.cast(__MODULE__, :shutdown)
  end

  # GenServer Implementation

  def init(stash_id) do
    current_stack = Stack.Stash.get_value(stash_id)
    {:ok, {stash_id, current_stack}}
  end

  def handle_call(:pop, _from, {stash_pid, [hd | tl]}) do
    {:reply, hd, {stash_pid, tl}}
  end
  def handle_call(:get_stack, _from, state = {_stash_pid, current_stack}) do
    {:reply, current_stack, state}
  end

  def handle_cast({:push, value}, {stash_pid, current_stack}) do
    {:noreply, {stash_pid, [value | current_stack]}}
  end
  def handle_cast(:shutdown, state) do
    {:stop, :shutdown, state}
  end

  def terminate(_reason, state = {stash_pid, current_stack}) do
    Stack.Stash.save_value(stash_pid, current_stack)
    {:noreply, state}
  end
end
