defmodule Grid.KioskSlide do
  use Grid.Web, :model

  schema "kiosk_slides" do
    belongs_to :kiosk, Grid.Kiosk
    belongs_to :slide, Grid.Slide

    timestamps
  end

  @required_fields ~w(kiosk_id slide_id)
  @optional_fields ~w()

  @creation_fields ~w(kiosk_id slide_id)
  def creation_changeset(kiosk_id, slide_id) do
    %__MODULE__{}
    |> cast(%{kiosk_id: kiosk_id, slide_id: slide_id}, @creation_fields, [])
    |> foreign_key_constraint(:kiosk_id)
    |> foreign_key_constraint(:slide_id)
  end
end
