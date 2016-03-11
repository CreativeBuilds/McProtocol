defmodule McProtocol.Handler.Handshake do
  @behaviour McProtocol.Handler

  alias McProtocol.Packets.Client

  def parent_handler, do: :connect

  def initial_state(proto_state = %{ mode: :init }) do
    proto_state
  end

  def state_atom(1), do: :status
  def state_atom(2), do: :login

  def handle(packet_data, state) do
    packet = Client.read_packet(packet_data, :init)
    %Client.Init.Handshake{} = packet

    state = %{ state |
      mode: state_atom(packet.next_mode)
    }

    case state.mode do
      :status -> {[{:next, McProtocol.Handler.Status, state}], state}
      :login -> {[{:next, state}], state}
    end
  end
end
