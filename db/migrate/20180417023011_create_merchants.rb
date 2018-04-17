class CreateMerchants < ActiveRecord::Migration[5.1]
  def change
    create_table :merchants do |t|
      t.string :merchant_id
      t.text :merchant_info

      t.timestamps
    end
  end
end
