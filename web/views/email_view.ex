defmodule Grid.EmailView do
  use Grid.Web, :view

  def date_string(stamp) do
    Ecto.DateTime.to_erl(stamp)
    |> Calendar.DateTime.from_erl!("MST")
    |> Calendar.Strftime.strftime!("%a, %B %e, %Y")
  end

  def time_string(stamp) do
    Ecto.DateTime.to_erl(stamp)
    |> Calendar.DateTime.from_erl!("MST")
    |> Calendar.Strftime.strftime!("%I:%M%P")
  end

  def date_time_string(stamp) do
    ~E"""
    <%= date_string(stamp) %>
    <span class="small" style="font-size: 11px;">at</span>
    <%= time_string(stamp) %>
    """
  end

  def duration_string(stamp) do
    ~E"""
    <%= div(stamp, 60) %>:<%= rem(stamp, 60) |> to_string |> String.rjust(2, ?0) %>
    """
  end

  def people_count(%{"items" => items}) do
    count = Enum.reduce(items, 0, fn(i, acc) ->
      acc + i["quantity"] * i["price_people_count"]
    end)

    case count do
      1 -> "1 person"
      n -> "#{n} people"
    end
  end

  def location(%{meeting_location: loc}) do
    if loc do
      ~E"""
      Vendor Office:
      <%= loc.address1 %>,
      <%= if a2=loc.address2 do %>
        <%= a2 %>,
      <% end %>
      <%= loc.city %>,
      <%= loc.state %>
      <%= loc.zip %>
      """
    else
      ~E"""
      Pick Up:
      Vendor will contact you the day before to arrange pickup details
      """
    end
  end

  def item_amount_display(order_item, order) do
    if coupon = order.coupon do
      ~E"""
      <del><%= order_item.amount |> number_to_currency %></del>
      <%= order_item |> item_amount_after_coupon(order) |> number_to_currency %>
      (with <%= coupon["percent_off"] %>% off coupon)
      """
    else
      ~E"""
      <%= order_item.amount |> number_to_currency %>
      """
    end
  end

  def item_amount_after_coupon(order_item) do
    item_amount_after_coupon(order_item, order_item.order)
  end

  def item_amount_after_coupon(order_item, order) do
    percent_off = order.coupon["percent_off"] || 0
    order_item.amount * (1 - percent_off / 100)
  end

  def order_total_after_coupon(order) do
    Grid.Admin.OrderView.total_after_coupon(order)
  end
end
