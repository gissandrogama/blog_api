defmodule BlogApiWeb.Auth.ErrorHandler do
  use BlogApiWeb, :controller

  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> put_resp_content_type("aplication/json")
    |> send_resp(401, Jason.encode!(%{error: to_string(type)}))
  end
end
