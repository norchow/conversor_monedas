class MoneyAmount
    attr_accessor :amount, :currency

    def initialize(amount, currency)
        self.amount = amount
        self.currency = currency
    end

    def equals(another_amount)
        self.amount == another_amount.amount && self.currency == another_amount.currency
    end

    def *(coefficient)
        @newAmount = MoneyAmount.new(self.amount * coefficient, self.currency)
        @newAmount
    end

    def +(another_amount)
        #use the first operator's currency
        another_amount_with_correct_currency = another_amount.transform_to(self.currency) 

        @newAmount = MoneyAmount.new(
            self.amount + another_amount_with_correct_currency.amount,
            self.currency )
        @newAmount
    end

    def transform_to(currency)
        @newAmount = MoneyAmount.new(
            self.amount * (self.currency.value / currency.value),
            currency)
        @newAmount
    end

    def to_s
        "#{self.amount} #{self.currency}"
    end
end

class Currency 
    attr_accessor :denomination, :value

    def initialize(denomination, value)
        self.denomination = denomination
        self.value = value
    end
end

class Converter
    attr_accessor :currencies

    def currencies
        @currencies = @currencies || Array.new
    end

    def add_currency(currency)
        self.currencies << currency
    end

    def convert(amount, currency)
        if ((self.currencies.include? amount.currency) and (self.currencies.include? currency))
            return amount.transform_to(currency)
        else
            raise NoCurrencyError.new("These currencies are not supported by this converter")
        end
    end
end

class NoCurrencyError < RuntimeError
end