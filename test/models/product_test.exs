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

  defp start_time_with_season(start_date, end_date) do
    Factory.create_start_time(season: Factory.create(:season,
      start_date: Ecto.Date.cast!(start_date),
      end_date: Ecto.Date.cast!(end_date)
    ))
  end
  defp products_for_date(date) do
    import Ecto.Query, only: [select: 3]

    Ecto.Date.cast!(date)
    |> Product.for_date
    |> select([p], p.id)
    |> Repo.all
  end

  test "Product.for_date for ranges" do
    early_start = {2016, 4,  1}
    early_mid   = {2016, 6, 30}
    early_end   = {2016, 7,  4}
    %{product: early_p} = start_time_with_season(early_start, early_end)
    start_date = {2016, 6, 15}
    mid_date   = {2016, 8, 25}
    end_date   = {2016, 9, 30}
    %{product: product} = start_time_with_season(start_date, end_date)
    late_start = {2016, 8, 30}
    late_mid   = {2016, 9,  1}
    late_end   = {2017, 1, 20}
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

    p_ids = products_for_date({2016, 1, 1})
    refute early_p.id in p_ids
    refute product.id in p_ids
    refute late_p.id in p_ids

    p_ids = products_for_date({2017, 5, 1})
    refute early_p.id in p_ids
    refute product.id in p_ids
    refute late_p.id in p_ids
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

    sd = monday |> Date.advance!(-1)
    ed = sunday |> Date.advance!(1)
    start_time = start_time_with_season(sd, ed)

    start_time
    |> Ecto.Changeset.change(monday: false, wednesday: false, saturday: false)
    |> Repo.update!

    hit = [start_time.product.id]
    miss = []

    assert products_for_date(monday) == miss
    assert products_for_date(tuesday) == hit
    assert products_for_date(wednesday) == miss
    assert products_for_date(thursday) == hit
    assert products_for_date(friday) == hit
    assert products_for_date(saturday) == miss
    assert products_for_date(sunday) == hit
  end
end
