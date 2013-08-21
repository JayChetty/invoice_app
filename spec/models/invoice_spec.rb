require 'spec_helper'

describe Invoice do
  it{should respond_to(:invoice_type)}
  it{should respond_to(:xero_id)}
  it{should respond_to(:contact_name)}
  it{should respond_to(:due_date)}
  it{should respond_to(:paid)}
  it{should respond_to(:due)}
  it{should respond_to(:total)}
  it{should respond_to(:status)}

  describe "Invoice class methods" do
  	it "should allow sync with xero" do
  		Invoice.should respond_to(:sync_with_xero)
  	end
  	it "should give total sums" do
  		Invoice.should respond_to(:due_totals)
  	end
  end

end
