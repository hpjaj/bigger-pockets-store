class ConferenceTicketOrder
  def initialize(order_number, quantity, address)
    @order_number = order_number
    @quantity = quantity
    @address = address
  end
 
  def charge(payment_type)
    shipping = 0
 
    if payment_type == :cash
      send_email_receipt
      @status = "charged"
    elsif payment_type == :cheque
      send_email_receipt
      @status = "charged"
    elsif payment_type == :paypal
      charge_paypal_account shipping + (quantity * 300)
      send_email_receipt
      @status = "charged"
    elsif payment_type == :stripe
      charge_credit_card shipping + (quantity * 300)
      send_email_receipt
      @status = "charged"
    end
  end
 
  def ship
    # [print ticket]
    # [print shipping label]
 
    @status = "shipped"
  end
 
  def quantity
    @quantity
  end
 
  def status
    @status
  end
 
  def to_s
    shipping = 0
    report = "Order ##{@order_number}\n"
    report += "Ship to: #{@address.join(", ")}\n"
    report += "-----\n\n"
    report += "Qty   | Item Name                       | Total\n"
    report += "------|---------------------------------|------\n"
    report += "#{@quantity}     |"
    report += " Conference Ticket               |"
    report += " $#{shipping + (quantity * 300.0)}"
    report
    return report
  end
 
  def shipping_cost
    shipping = 0
  end
 
  def send_email_receipt
    # [send email receipt]
  end
 
  # In real life, charges would happen here. For sake of this test, it simply returns true
  def charge_paypal_account(amount)
    true
  end
 
  # In real life, charges would happen here. For sake of this test, it simply returns true
  def charge_credit_card(amount)
    true
  end
end