defmodule Stack.Stash do
  use GenServer

  # API Client Implementation

  def start_link(initial_stack) do
    GenServer.start_link(__MODULE__, initial_stack)
  end

  def get_value(pid) do
    GenServer.call(pid, :get_value)
  end

  def save_value(pid, value) do
    GenServer.cast(pid, {:save_value, value})
  end

  # GenServer Callbacks Implementation

  def handle_call(:get_value, _from, current_stack) do
    {:reply, current_stack, current_stack}
  end

  def handle_cast({:save_value, stack}, _current_stack) do
    {:noreply, stack}
  end
end
