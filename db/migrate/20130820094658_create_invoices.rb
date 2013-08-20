class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :xero_id
      t.string :invoice_type
      t.string :status
      t.string :contact_name
      t.date :due_date
      t.decimal :paid
      t.decimal :due
      t.decimal :total

      t.timestamps
    end
  end
end
