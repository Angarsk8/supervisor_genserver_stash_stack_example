defmodule Stack.SubSupervisor do
  use Supervisor

  def start_link(stash_id) do
    Supervisor.start_link(__MODULE__, stash_id)
  end

  # Supervisor Callbacks

  def init(stash_id) do
    child_processes = [
      worker(Stack.Server, [stash_id])
    ]
    supervise(child_processes, strategy: :one_for_one)
  end
end
