defmodule Grid.ProductTest do
  use Grid.ModelCase

  alias Grid.Product
  import Ecto.Changeset, only: [fetch_field: 2]

  @valid_attrs %{description: "some content", name: "some content", duration: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Product.changeset(%Product{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Product.changeset(%Product{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "creation_changeset with valid attributes" do
    vendor = Factory.create(:vendor)
    experience = Factory.create(:experience)
    attrs = @valid_attrs |> Map.put(:experience_id, experience.id)
    changeset = Product.creation_changeset(attrs, vendor.id)
    assert changeset.valid?
  end

  test "creation_changeset with invalid attributes" do
    changeset = Product.creation_changeset(@invalid_attrs, 2)
    refute changeset.valid?
  end

  test "setting pickup to false without providing a location errors" do
    params = @valid_attrs |> Map.put(:pickup, false)
    changeset = Product.changeset(%Product{}, params)
    assert [meeting_location_id: "Please supply a meeting location."] == changeset.errors
  end

  test "Selecting a location sets pickup to false" do
    params = @valid_attrs |> Map.put(:meeting_location_id, 1)
    changeset = Product.changeset(%Product{}, params)
    assert {:changes, false} == fetch_field(changeset, :pickup)
  end

  test "Setting pickup to true clears the meeting location id" do
    params = @valid_attrs |> Map.put(:pickup, true)
    changeset = Product.changeset(%Product{meeting_location_id: 1, pickup: false}, params)
    assert {:changes, nil} == fetch_field(changeset, :meeting_location_id)
  end

  ############### Repo tests

  defp start_time_with_season({sm, sd}, {em, ed}) do
    Factory.create_start_time(season: Factory.create(:season,
      start_date_month: sm, start_date_day: sd,
        end_date_month: em,   end_date_day: ed
    ))
  end
  defp datify({month, day}) do
    {year, _, _} = :erlang.date()
    %{year: year, month: month, day: day}
  end
  defp products_for_date(m_d) do
    import Ecto.Query, only: [select: 3]
    m_d
    |> datify
    |> Product.for_date
    |> select([p], p.id)
    |> Repo.all
  end

  test "Product.for_date for straightforward ranges (beginning < end)" do
    early_start = {4,  1}
    early_mid   = {6, 30}
    early_end   = {7,  4}
    %{product: early_p} = start_time_with_season(early_start, early_end)
    start_date = {6, 15}
    mid_date   = {8, 25}
    end_date   = {9, 30}
    %{product: product} = start_time_with_season(start_date, end_date)
    late_start = {8, 30}
    late_mid   = {9,  1}
    late_end   = {10, 20}
    %{product: late_p} = start_time_with_season(late_start, late_end)

    p_ids = products_for_date(early_start)
    assert early_p.id in p_ids
    refute product.id in p_ids
    refute late_p.id in p_ids

    p_ids = products_for_date(early_mid)
    assert early_p.id in p_ids
    assert product.id in p_ids
    refute late_p.id in p_ids

    p_ids = products_for_date(early_end)
    assert early_p.id in p_ids
    assert product.id in p_ids
    refute late_p.id in p_ids

    p_ids = products_for_date(start_date)
    assert early_p.id in p_ids
    assert product.id in p_ids
    refute late_p.id in p_ids

    p_ids = products_for_date(mid_date)
    refute early_p.id in p_ids
    assert product.id in p_ids
    refute late_p.id in p_ids

    p_ids = products_for_date(end_date)
    refute early_p.id in p_ids
    assert product.id in p_ids
    assert late_p.id in p_ids

    p_ids = products_for_date(late_start)
    refute early_p.id in p_ids
    assert product.id in p_ids
    assert late_p.id in p_ids

    p_ids = products_for_date(late_mid)
    refute early_p.id in p_ids
    assert product.id in p_ids
    assert late_p.id in p_ids

    p_ids = products_for_date(late_end)
    refute early_p.id in p_ids
    refute product.id in p_ids
    assert late_p.id in p_ids

    p_ids = products_for_date({1, 1})
    refute early_p.id in p_ids
    refute product.id in p_ids
    refute late_p.id in p_ids

    p_ids = products_for_date({12, 31})
    refute early_p.id in p_ids
    refute product.id in p_ids
    refute late_p.id in p_ids
  end

  test "Product.for_date for ranges that hurt your head (end < beginning)" do
    early_start = {7,  4}
    early_end   = {4,  1}
    %{product: early_p} = start_time_with_season(early_start, early_end)
    start_date = {9, 30}
    end_date   = {6, 15}
    %{product: product} = start_time_with_season(start_date, end_date)
    late_start = {10, 20}
    late_end   = {8, 30}
    %{product: late_p} = start_time_with_season(late_start, late_end)

    p_ids = products_for_date(early_start)
    assert early_p.id in p_ids
    refute product.id in p_ids
    assert late_p.id in p_ids

    p_ids = products_for_date(early_end)
    assert early_p.id in p_ids
    assert product.id in p_ids
    assert late_p.id in p_ids

    p_ids = products_for_date(start_date)
    assert early_p.id in p_ids
    assert product.id in p_ids
    refute late_p.id in p_ids

    p_ids = products_for_date(end_date)
    refute early_p.id in p_ids
    assert product.id in p_ids
    assert late_p.id in p_ids

    p_ids = products_for_date(late_start)
    assert early_p.id in p_ids
    assert product.id in p_ids
    assert late_p.id in p_ids

    p_ids = products_for_date(late_end)
    assert early_p.id in p_ids
    refute product.id in p_ids
    assert late_p.id in p_ids

    p_ids = products_for_date({1, 1})
    assert early_p.id in p_ids
    assert product.id in p_ids
    assert late_p.id in p_ids

    p_ids = products_for_date({12, 31})
    assert early_p.id in p_ids
    assert product.id in p_ids
    assert late_p.id in p_ids
  end

  test "Product date filtering with select days of the week" do
    alias Calendar.{Date, DateTime}
    [
      monday,
      tuesday,
      wednesday,
      thursday,
      friday,
      saturday,
      sunday
    ] = DateTime.now_utc
      |> Date.advance!(10)
      |> Date.week_number
      |> Date.dates_for_week_number

    %{month: sm, day: sd} = monday |> Date.advance!(-1)
    %{month: em, day: ed} = sunday |> Date.advance!(1)
    start_time = start_time_with_season({sm, sd}, {em, ed})

    start_time
    |> Ecto.Changeset.change(monday: false, wednesday: false, saturday: false)
    |> Repo.update!

    hit = [start_time.product.id]
    miss = []

    %{month: m, day: d} = monday
    assert products_for_date({m, d}) == miss

    %{month: m, day: d} = tuesday
    assert products_for_date({m, d}) == hit

    %{month: m, day: d} = wednesday
    assert products_for_date({m, d}) == miss

    %{month: m, day: d} = thursday
    assert products_for_date({m, d}) == hit

    %{month: m, day: d} = friday
    assert products_for_date({m, d}) == hit

    %{month: m, day: d} = saturday
    assert products_for_date({m, d}) == miss

    %{month: m, day: d} = sunday
    assert products_for_date({m, d}) == hit
  end
  
  test "Product date filtering only returns published products" do
    %{product: product} = start_time_with_season({4,  1}, {7,  4})
    assert products_for_date({5, 1}) == [product.id]
    Ecto.Changeset.change(product, published: false) |> Repo.update!
    assert products_for_date({5, 1}) == []
  end
end
