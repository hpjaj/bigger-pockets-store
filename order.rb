class Order

  require 'json'

  attr_accessor :shipping, :quantity, :status

  NO_SHIPPING_COST_ORDER_TYPES = ["ebook", "confernce_ticket"]

  ITEMS_DETAILS = {
    "ebook" => { cost: 14.95, name: "eBook" },
    "confernce_ticket" => { cost: 300, name: "Conference Ticket" },
    "print" => { cost: 14.95, name: "Book" }
  }

  def initialize(order_type, order_number, quantity, address)
    @order_type = order_number
    @order_number = order_number
    @quantity = quantity
    @address = address

    if order_type == 'confernce_ticket' && quantity > 1  
      raise ArgumentError.new('Conference tickets are limited to one per customer')  
    end
  end

  def charge(order_type, payment_type)
    shipping_cost(order_type)

    if payment_type == :paypal 
      if charge_paypal_account( shipping + (quantity * item_cost(order_type)) )
        success_charge_workflow
      else
        failure_charge_workflow
      end
    elsif payment_type == :stripe
      if charge_credit_card( shipping + (quantity * item_cost(order_type)) )
        success_charge_workflow
      else
        failure_charge_workflow
      end
    else
      success_charge_workflow
    end
  end

  def ship(order_type) 
    if order_type == "ebook"
      # [send email with download link...]
    elsif order_type == 'confernce_ticket'
      # [print ticket]
      # [print shipping label]  
    else
      # [print shipping label]
    end
 
    @status = "shipped"
  end

  def shipping_cost(order_type)
    if NO_SHIPPING_COST_ORDER_TYPES.include?(order_type)
      @shipping = 0
    else
      @shipping = 4.99
    end
  end

  def to_s(order_type)
    shipping_cost(order_type)

    report = "Order ##{@order_number}\n"
    report += "Ship to: #{@address.join(", ")}\n"
    report += "-----\n\n"
    report += "Qty   | Item Name                       | Total\n"
    report += "------|---------------------------------|------\n"
    report += "#{@quantity}     |"
    report += " #{item_name(order_type)}               |"
    report += " $#{total_cost(order_type)}"
  end

  ## once data is in JSON, can be consumed by through an API
  ## and convertered into HTML, XML, etc.
  def order_in_json(order_type)
    shipping_cost(order_type)
    order = { 
      order_number: @order_number, address: @address, order_details: {
        item_1: { item_name: item_name(order_type), item_qty: @quantity, item_cost: item_cost(order_type) }
        },
      total: total_cost(order_type).to_f
      }
    order.to_json
  end
  

private

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

  def item_cost(order_type)
    ITEMS_DETAILS[order_type][:cost]
  end

  def item_name(order_type)
    ITEMS_DETAILS[order_type][:name]
  end

  def success_charge_workflow
    send_email_receipt
    @status = "charged"
  end

  def failure_charge_workflow
    send_payment_failure_email
    @status = "failed"
  end

  def total_cost(order_type)
    '%.2f' % (shipping + (quantity * item_cost(order_type)).round(2))
  end

end