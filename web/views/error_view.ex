defmodule Grid.ErrorView do
  use Grid.Web, :view

  alias Grid.{
    CartError,
    ChangesetView
  }

  require Logger

  ##################
  ##     HTML     ##
  ##################

  def render("404.html", assigns) do
    render("not_found.html", assigns)
  end

  def render("500.html", assigns) do
    render("server_error.html", assigns)
  end

  ##################
  ##     JSON     ##
  ##################

  # Ugly but necessary pattern matching on the end of a string
  def render(<<status :: size(24), ".json">>, %{reason: exception}) do
    status = :binary.encode_unsigned(status)
    errors = render_one(exception,  __MODULE__, "exception.json", status: status)
    %{errors: List.wrap(errors)}
  end

  def render("404.json", _assigns) do
    %{errors: [%{status: 404, type: "NotFoundError", message: "Not found"}]}
  end

  def render("500.json", %{view_template: "500.json"}) do
    %{errors: [%{status: 500, message: "Server error", type: "ServerError"}]}
  end
  # errors that didn't have a template, see `template_not_found/2`
  def render("500.json", _assigns) do
    %{status: 500, message: "Unknown error", type: "ServerError"}
  end

  ############################
  ##     JSON Exceptions    ##
  ############################

  def render("exception.json", %{error: cart_error = %CartError{}, status: status}) do
    %{
      message: cart_error.message,
      product: cart_error.product,
      type: "CartError",
      status: status
    }
  end

  def render("exception.json", %{error: %Ecto.NoResultsError{}}) do
    %{
      message: "Not found",
      type: "NotFoundError",
      status: 404
    }
  end

  def render("exception.json", %{error: missing_param_error = %Phoenix.MissingParamError{}, status: status}) do
    [_, key] = Regex.run(~r/^expected key "(.*)"/, missing_param_error.message)
    %{
      message: "Missing required key: #{key}",
      key: key,
      type: "MissingParamError",
      status: status
    }
  end

  def render("exception.json", %{error: %Ecto.InvalidChangesetError{changeset: changeset}, status: status}) do
    for {key, messages} <- ChangesetView.translate_errors(changeset) do
      for message <- messages do
        %{
          key: key,
          type: "ValidationError",
          message: message,
          status: status
        }
      end
    end
    |> List.flatten
  end

  def template_not_found("exception.json", %{error: _}) do
    %{
      type: "ServerError",
      message: "An unknown error has occurred",
      status: 500
    }
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(template, assigns) do
    isJson = String.ends_with? template, ".json"
    if isJson do
      render "500.json", assigns
    else
      render "500.html", assigns
    end
  end
end
