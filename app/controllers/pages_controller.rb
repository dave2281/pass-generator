class PagesController < ApplicationController
  def password
    length = params[:length].to_i
    include_symbols = params[:include_symbols] == '1'
    include_numbers = params[:include_numbers] == '1'
    @password = generate_password(length, include_symbols, include_numbers)
    @bits = keepass_password_bits(@password)

    respond_to do |format|
      format.html { render :password }
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace(@password, partial:"password/password", locals: {password: @password})
      }
    end
  end

  private

  def generate_password(length = 12, include_symbols = false, include_numbers = false)
    lower_case = ('a'..'z').to_a
    upper_case = ('A'..'Z').to_a
    numbers = ('0'..'9').to_a
    symbols = %w[! @ # $ % ^ & *]

    all_characters = lower_case + upper_case
    all_characters += symbols if include_symbols
    all_characters += numbers if include_numbers
    length = 128 if length > 128
    length = 0 if length < 0
    Array.new(length) { all_characters.sample }.join
  end

  def keepass_password_bits(password)
    digits = 10
    lowercase = 26
    uppercase = 26
    special = 20

    character_set_size = 0
  
    character_set_size += digits if password =~ /[0-9]/
    character_set_size += lowercase if password =~ /[a-z]/
    character_set_size += uppercase if password =~ /[A-Z]/
    character_set_size += special if password =~ /[^a-zA-Z0-9]/
  
    return 0 if character_set_size == 0
  
    if password =~ /^[a-zA-Z0-9]+$/
      character_set_size = 62
    end
  
    bit_strength = password.length * Math.log2(character_set_size)
    return bit_strength.round
  end
end
