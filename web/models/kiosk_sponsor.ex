defmodule Grid.KioskSponsor do
  use Grid.Web, :model

  schema "kiosk_sponsors" do
    belongs_to :kiosk, Grid.Kiosk
    belongs_to :vendor, Grid.Vendor

    timestamps
  end

  @creation_fields ~w(kiosk_id vendor_id)
  def creation_changeset(kiosk_id, vendor_id) do
    %__MODULE__{}
    |> cast(%{kiosk_id: kiosk_id, vendor_id: vendor_id}, @creation_fields, [])
    |> foreign_key_constraint(:kiosk_id)
    |> foreign_key_constraint(:vendor_id)
  end
end
