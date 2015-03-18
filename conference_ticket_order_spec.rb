require_relative "order"


RSpec.describe Order do
  context "a valid conference ticket order" do
    subject do
      Order.new("confernce_ticket", 3, 1, ["1234 Main St.", "New York, NY 12345"])
    end
 
    it "gets marked as charged" do
      subject.charge("confernce_ticket", :paypal)
 
      expect(subject.status).to eq("charged")
    end
 
    it "gets marked as shipped" do
      subject.ship("confernce_ticket")
 
      expect(subject.status).to eq("shipped")
    end
 
    it "calculates shipping cost" do
      shipping_cost = subject.shipping_cost('confernce_ticket')
 
      expect(shipping_cost).to eq(0)
    end

  context "order can be reported"
    subject do
      Order.new("confernce_ticket", 12345, 1, ["1234 Test St.", "New York, NY 12345"])
    end

    it "though a text-based report" do
      report = "Order #12345\n" \
               "Ship to: 1234 Test St., New York, NY 12345\n" \
               "-----\n\n" \
               "Qty   | Item Name                       | Total\n" \
               "------|---------------------------------|------\n" \
               "1     | Conference Ticket               | $300.00"
 
      expect(subject.to_s("confernce_ticket")).to eq(report)
    end

    it "through the JSON format" do
      json_data = subject.order_in_json("confernce_ticket")

      expect( json_data ).to eq("{\"order_number\":12345,\"address\":[\"1234 Test St.\",\"New York, NY 12345\"],\"order_details\":{\"item_1\":{\"item_name\":\"Conference Ticket\",\"item_qty\":1,\"item_cost\":300}},\"total\":300.0}")
    end

  end
 
  it "does not allow more than one conference ticket per order" do
    expect do
      Order.new("confernce_ticket", 1337, 3, ["456 Test St.", "New York, NY 12345"])
    end.to raise_error("Conference tickets are limited to one per customer")
  end

end