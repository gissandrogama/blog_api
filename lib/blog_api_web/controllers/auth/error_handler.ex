defmodule BlogApiWeb.Auth.ErrorHandler do
  @moduledoc """
  this model has functions that return guardian errors
  """
  use BlogApiWeb, :controller

  def auth_error(conn, {type, _reason}, _opts) do
    case type do
      :invalid_token ->
        conn
        |> put_resp_content_type("aplication/json")
        |> send_resp(401, Jason.encode!(%{error: "Token expirado ou inválido"}))

      :unauthenticated ->
        conn
        |> put_resp_content_type("aplication/json")
        |> send_resp(401, Jason.encode!(%{error: "Token não encontrado"}))
    end
  end
end
