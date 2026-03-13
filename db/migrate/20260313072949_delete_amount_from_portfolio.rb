class DeleteAmountFromPortfolio < ActiveRecord::Migration[7.1]
  def change
    remove_column :portfolios, :amount, :decimal
  end
end
