defmodule Carbon.HttpRequest do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://api.carbonintensity.org.uk")
  plug(Tesla.Middleware.JSON)

  def intensity() do
    get("/intensity")
  end

  def intensity(date) do
    get("/intensity/date/" <> date)
  end

  def intensity(date, period) do
    get("/intensity/date/" <> date <> "/" <> period)
  end
end
