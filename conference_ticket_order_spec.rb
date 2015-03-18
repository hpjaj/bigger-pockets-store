require_relative "conference_ticket_order"

RSpec.describe ConferenceTicketOrder do
  context "a valid conference ticket order" do
    subject do
      ConferenceTicketOrder.new(3, 1, ["1234 Main St.", "New York, NY 12345"])
    end
 
    it "gets marked as charged" do
      subject.charge(:paypal)
 
      expect(subject.status).to eq("charged")
    end
 
    it "gets marked as shipped" do
      subject.ship
 
      expect(subject.status).to eq("shipped")
    end
 
    it "calculates shipping cost" do
      shipping_cost = subject.shipping_cost
 
      expect(shipping_cost).to eq(0)
    end
 
    it "produces a text-based report" do
      order = ConferenceTicketOrder.new(12345,
                                        1,
                                        ["1234 Test St.", "New York, NY 12345"])
      report = "Order #12345\n" \
               "Ship to: 1234 Test St., New York, NY 12345\n" \
               "-----\n\n" \
               "Qty   | Item Name                       | Total\n" \
               "------|---------------------------------|------\n" \
               "1     | Conference Ticket               | $300.00"
 
      expect(order.to_s).to eq(report)
    end
  end
 
  it "does not allow more than one conference ticket per order" do
    expect do
      ConferenceTicketOrder.new(1337, 3, ["456 Test St.", "New York, NY 12345"])
    end.to raise_error("Conference tickets are limited to one per customer")
  end
end