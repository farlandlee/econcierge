defmodule Grid.SlideTest do
  use Grid.ModelCase

  alias Grid.Slide

  @valid_attrs %{name: "Slide!", action_link: "http://test.com/book", action_label: "Book!", photo_url: "http://test.com/a.jpeg", title: "some content", title_label: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Slide.changeset(%Slide{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Slide.changeset(%Slide{}, @invalid_attrs)
    refute changeset.valid?
  end
end
