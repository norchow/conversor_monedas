require 'rspec'
require_relative '../src/conversor'

describe 'Conversor tests' do
    before(:all) do
        @peso = Currency.new('ARS', 1)
        @dolarOficial = Currency.new('USD', 10)
        @dolarBlue = Currency.new('USD', 15)
        @dolarTarjeta = Currency.new('USD', 12)

        @banco = Converter.new
        @banco.add_currency(@peso)
        @banco.add_currency(@dolarOficial)
        @banco.add_currency(@dolarTarjeta)
    end

    it 'Se suman dos valores en la misma moneda' do
        billetera = MoneyAmount.new(100, @peso)
        vuelto = MoneyAmount.new(11, @peso)
        billetera += vuelto
        expect(billetera.amount).to eq(111)
        expect(billetera.currency).to eq(@peso)
    end

    it 'Multiplicar un valor por un numero' do
        billetera = MoneyAmount.new(100, @peso)
        billetera = billetera*3
        expect(billetera.amount).to eq(300)
        expect(billetera.currency).to eq(@peso)
    end


    it 'Sumar reduciendo a una moneda' do
        billetera = MoneyAmount.new(100, @peso)
        vuelto = MoneyAmount.new(1, @dolarOficial)
        billetera += vuelto
        expect(billetera.amount).to eq(110)
        expect(billetera.currency).to eq(@peso)
    end

    it 'Convertir una moneda a otra posible' do
        vuelto = MoneyAmount.new(1, @dolarOficial)
        @banco.convert(vuelto, @peso)
        expect(vuelto.amount).to eq(10)
        expect(vuelto.currency).to eq(@peso)
    end

    it 'Convertir una moneda a otra posible' do
        vuelto = MoneyAmount.new(15, @peso)
        expect { @banco.convert(vuelto, @dolarBlue) }.to raise_error(NoCurrencyError)
    end
end