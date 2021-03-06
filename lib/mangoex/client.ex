defmodule Mangoex.Client do
  use GenServer
  @behaviour Mangoex.Behaviour
  @client_name Mangoex.Client

  # Client API

  def start_link do
    initial_state = %{}
    GenServer.start_link(__MODULE__, initial_state, [name: @client_name])
  end

  def auth(client_id, client_pass) do
    GenServer.call(@client_name, {:auth, client_id, client_pass})
  end

  def list_users do
    GenServer.call(@client_name, {:list_users})
  end

  def create_payin(type, body) do
    GenServer.call(@client_name, {:create_payin, type, body})
  end

  def get_payin(payin_id) do
    GenServer.call(@client_name, {:get_payin, payin_id})
  end

  def create_refund(type, payin_id, body) do
    GenServer.call(@client_name, {:create_refund, type, payin_id, body})
  end

  def create_card(body) do
    GenServer.call(@client_name, {:create_card, body})
  end

  def create_wallet(body) do
    GenServer.call(@client_name, {:create_wallet, body})
  end

  def create_bank_account(type, user_id, body) do
    GenServer.call(@client_name, {:create_bank_account, type, user_id, body})
  end

  def create_kyc_document(user_id, body) do
    GenServer.call(@client_name, {:create_kyc_document, user_id, body})
  end

  def create_kyc_page(user_id, kyc_document_id, body) do
    GenServer.call(@client_name, {:create_kyc_page, user_id, kyc_document_id, body})
  end

  def submit_kyc_document(user_id, kyc_document_id, body) do
    GenServer.call(@client_name, {:submit_kyc_document, user_id, kyc_document_id, body})
  end

  # GenServer callbacks

  def handle_call({:auth, client_id, client_pass}, _from, state) do
    resp = Mangoex.Api.authenticate(client_id, client_pass)

    case resp do
      {:ok, body} ->
        new_state = state
        |> Map.put(:token, body["access_token"])
        |> Map.put(:client_id, client_id)

        {:reply, body, new_state}
      {:error, body} ->
        {:reply, body, state}
    end
  end

  def handle_call({:list_users}, _from, state) do
    resp = Mangoex.Api.list_users(state[:client_id], state[:token])
    {:reply, resp, state}
  end

  def handle_call({:create_wallet, body}, _from, state) do
    resp = Mangoex.Api.create_wallet(
      state[:client_id],
      state[:token],
      body
    )
    {:reply, resp, state}
  end

  def handle_call({:create_payin, :bankwire_direct, body}, _from, state) do
    resp = Mangoex.Api.create_payin(
      :bankwire_direct,
      state[:client_id],
      state[:token],
      body
    )
    {:reply, resp, state}
  end

  def handle_call({:create_payin, :card_direct, body}, _from, state) do
    resp = Mangoex.Api.create_payin(
      :card_direct,
      state[:client_id],
      state[:token],
      body
    )
    {:reply, resp, state}
  end

  def handle_call({:get_payin, payin_id}, _from, state) do
    resp = Mangoex.Api.get_payin(
      state[:client_id],
      payin_id,
      state[:token]
    )
    {:reply, resp, state}
  end

  def handle_call({:create_refund, :payin, payin_id, body}, _from, state) do
    resp = Mangoex.Api.create_refund(
      :payin,
      state[:client_id],
      payin_id,
      state[:token],
      body
    )
    {:reply, resp, state}
  end

  def handle_call({:create_card, body}, _from, state) do
    resp = Mangoex.Api.create_card(
      state[:client_id],
      state[:token],
      body
    )
    {:reply, resp, state}
  end

  def handle_call({:create_bank_account, :gb, user_id, body}, _from, state) do
    resp = Mangoex.Api.create_gb_bank_account(
      state[:client_id],
      user_id,
      state[:token],
      body
    )
    {:reply, resp, state}
  end

  def handle_call({:create_kyc_document, user_id, body}, _from, state) do
    resp = Mangoex.Api.create_kyc_document(
      state[:client_id],
      user_id,
      state[:token],
      body
    )
    {:reply, resp, state}
  end

  def handle_call({:create_kyc_page, user_id, kyc_document_id, body}, _from, state) do
    resp = Mangoex.Api.create_kyc_page(
      state[:client_id],
      user_id,
      kyc_document_id,
      state[:token],
      body
    )
    {:reply, resp, state}
  end

  def handle_call({:submit_kyc_document, user_id, kyc_document_id, body}, _from, state) do
    resp = Mangoex.Api.submit_kyc_document(
      state[:client_id],
      user_id,
      kyc_document_id,
      state[:token],
      body
    )
    {:reply, resp, state}
  end
end
