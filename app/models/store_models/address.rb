module StoreModels
  class Address
    include StoreModel::Model

    attribute :street_name, :string
  end
end
