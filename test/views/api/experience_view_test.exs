defmodule Grid.Api.ExperienceViewTest do
  use Grid.ConnCase

  import Grid.Api.ExperienceView

  @rendered_keys ~w(id name description slug image)a
  test "render vendor" do
    activity = Factory.create(:activity)
    image = Factory.create_activity_image(assoc_id: activity.id)
    experience = Factory.create(:experience, activity: activity, image: image)

    rendered = render("experience.json", %{experience: experience})

    # Renders expected keys
    for key <- @rendered_keys do
      assert_key(key, experience, rendered)
    end

    # no extra keys
    assert Map.keys(rendered) |> Enum.count() == Enum.count(@rendered_keys)
  end

  defp assert_key(:image, experience, rendered) do
    assert rendered.image.alt == experience.image.alt
  end

  defp assert_key(key, experience, rendered) do
    assert Map.has_key?(rendered, key)
    assert rendered[key] == Map.get(experience, key)
  end
end
