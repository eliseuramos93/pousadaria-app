class Checkout < ApplicationRecord
  # relationships
  belongs_to :reservation

  # validations
  validates :payment_method, presence: true

  # enums
  enum payment_method: {bank_transfer: 0, credit_card: 2, debit_card: 4, cash: 6,
                        deposit: 8}
end
