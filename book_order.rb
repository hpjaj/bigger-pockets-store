class BookOrder
  def initialize(order_number, quantity, address)
    @order_number = order_number
    @quantity = quantity
    @address = address
  end
 
  def charge(order_type, payment_type)
    if order_type == "ebook"
      shipping = 0
    else
      shipping = 5.99
    end
 
    if payment_type == :cash
      send_email_receipt
      @status = "charged"
    elsif payment_type == :cheque
      send_email_receipt
      @status = "charged"
    elsif payment_type == :paypal
      if charge_paypal_account(shipping + (quantity * 14.95))
        send_email_receipt
        @status = "charged"
      else
        send_payment_failure_email
        @status = "failed"
      end
    elsif payment_type == :stripe
      if charge_credit_card(shipping + (quantity * 14.95))
        send_email_receipt
        @status = "charged"
      else
        send_payment_failure_email
        @status = "failed"
      end
    end
  end
 
  def ship(order_type)
    if order_type == "ebook"
      # [send email with download link...]
    else
      # [print shipping label]
    end
 
    @status = "shipped"
  end
 
  def quantity
    @quantity
  end
 
  def status
    @status
  end
 
  def to_s(order_type)
    if order_type == "ebook"
      shipping = 0
    else
      shipping = 4.99
    end
 
    report = "Order ##{@order_number}\n"
    report += "Ship to: #{@address.join(", ")}\n"
    report += "-----\n\n"
    report += "Qty   | Item Name                       | Total\n"
    report += "------|---------------------------------|------\n"
    report += "#{@quantity}     | Book                            | $#{shipping + (quantity * 14.95)}"
    report
    return report
  end
 
  def shipping_cost(order_type)
    if order_type == "ebook"
      shipping = 0
    else
      shipping = 4.95
    end
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
