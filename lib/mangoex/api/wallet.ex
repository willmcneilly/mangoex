defmodule Mangoex.API.Wallet do
  import Mangoex.API.Base

  def create(client_id, token, body) do
    resp = request(:post, "/#{client_id}/wallets", body, token)
    decode_json(resp)
  end
end
