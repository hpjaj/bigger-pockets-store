require_relative "book_order"

 
RSpec.describe BookOrder do
  context "with a physical book" do
    subject { BookOrder.new(1, 5, ["1234 Main St.", "New York, NY 12345"]) }
 
    it "gets marked as charged" do
      subject.charge("print", :stripe)
 
      expect(subject.status).to eq("charged")
    end
 
    it "gets marked as shipped" do
      subject.ship("print")
 
      expect(subject.status).to eq("shipped")
    end
 
    it "calculates shipping cost" do
      shipping_cost = subject.shipping_cost("print")
 
      expect(shipping_cost).to eq(4.95)
    end
  end
 
  context "as an ebook" do
    subject { BookOrder.new(2, 5, ["1234 Main St.", "New York, NY 12345"]) }
 
    it "gets marked as charged" do
      subject.charge("ebook", :paypal)
 
      expect(subject.status).to eq("charged")
    end
 
    it "gets marked as shipped" do
      subject.ship("ebook")
 
      expect(subject.status).to eq("shipped")
    end
 
    it "calculates shipping cost" do
      shipping_cost = subject.shipping_cost("ebook")
 
      expect(shipping_cost).to eq(0)
    end
  end
 
  it "produces a text-based report" do
    order = BookOrder.new(12345, 5, ["1234 Main St.", "New York, NY 12345"])
    report = "Order #12345\n" \
             "Ship to: 1234 Main St., New York, NY 12345\n" \
             "-----\n\n" \
             "Qty   | Item Name                       | Total\n" \
             "------|---------------------------------|------\n" \
             "5     | Book                            | $79.74"
 
    expect(order.to_s("print")).to eq(report)
  end
end