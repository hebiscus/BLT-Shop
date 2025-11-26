require "rails_helper"

RSpec.describe Discount, type: :model do
  include ActiveSupport::Testing::TimeHelpers

  describe ".currently_valid" do
    before do
      travel_to Time.zone.parse("2025-02-01 12:00")
    end

    after { travel_back }

    context "when discount is enabled active" do
      context "but without date restrictions" do
        it "includes the discount" do
          discount = create(:discount, active: true, starts_at: nil, ends_at: nil)
          expect(Discount.currently_valid).to include(discount)
        end
      end

      context "with start date only" do
        it "includes discount already started" do
          discount = create(:discount, active: true, starts_at: 2.days.ago)
          expect(Discount.currently_valid).to include(discount)
        end

        it "excludes discount starting in the future" do
          discount = create(:discount, active: true, starts_at: 1.day.from_now)
          expect(Discount.currently_valid).not_to include(discount)
        end
      end

      context "with end date only" do
        it "includes discount not yet ended" do
          discount = create(:discount, active: true, ends_at: 1.day.from_now)
          expect(Discount.currently_valid).to include(discount)
        end

        it "excludes discount already ended" do
          discount = create(:discount, active: true, ends_at: 1.day.ago)
          expect(Discount.currently_valid).not_to include(discount)
        end
      end

      context "with both start and end dates" do
        it "includes discount in valid window" do
          discount = create(
            :discount,
            active: true,
            starts_at: 1.day.ago,
            ends_at: 1.day.from_now
          )
          expect(Discount.currently_valid).to include(discount)
        end

        it "excludes discount outside current window" do
          discount = create(
            :discount,
            active: true,
            starts_at: 3.days.from_now,
            ends_at: 4.days.from_now
          )
          expect(Discount.currently_valid).not_to include(discount)
        end
      end
    end

    context "when discount is not active" do
      it "never includes the discount even if dates match" do
        discount = create(
          :discount,
          active: false,
          starts_at: 1.day.ago,
          ends_at: 1.day.from_now
        )
        expect(Discount.currently_valid).not_to include(discount)
      end

      it "never includes the discount with no date restrictions" do
        discount = create(:discount, active: false)
        expect(Discount.currently_valid).not_to include(discount)
      end
    end
  end

  describe ".for_shop" do
    let!(:shop_a) { create(:shop, name: "A") }
    let!(:local_a_discount) do
      create(:discount, :local, shop: shop_a, name: "Local A")
    end

    let!(:shop_b) { create(:shop, name: "B") }
    let!(:local_b_discount) do
      create(:discount, :local, shop: shop_b, name: "Local B")
    end

    let!(:global_discount) { create(:discount, name: "Global") }

    it "returns global discounts + discounts scoped to the given shop" do
      result = Discount.for_shop(shop_a.id)

      expect(result).to include(global_discount, local_a_discount)
      expect(result).not_to include(local_b_discount)
    end

    it "returns ONLY global discounts for shops with no local entries" do
      new_shop = create(:shop, name: "C")

      expect(Discount.for_shop(new_shop.id)).to match_array([global_discount])
    end
  end
end
