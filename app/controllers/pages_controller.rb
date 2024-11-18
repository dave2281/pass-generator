class PagesController < ApplicationController
  def password
    length = params[:length].to_i
    include_symbols = params[:include_symbols] == '1'
    include_numbers = params[:include_numbers] == '1'
    include_uppercase = params[:include_uppercase] == '1'

    @password = generate_password(length, include_uppercase, include_symbols, include_numbers)
    @bits = calculate_entropy(@password)

    respond_to do |format|
      format.html { render :password }
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          'password-output', 
          partial: "password/password", 
          locals: { password: @password }
        )
      end
    end
  end

  private

  def generate_password(length = 12, include_uppercase = false, include_symbols = false, include_numbers = false)
    lower_case = ('a'..'z').to_a
    upper_case = ('A'..'Z').to_a
    numbers = ('0'..'9').to_a
    symbols = %w[! @ # $ % ^ & *]

    all_characters = lower_case
    all_characters += upper_case if include_uppercase
    all_characters += symbols if include_symbols
    all_characters += numbers if include_numbers

    length = 128 if length > 128
    length = 8 if length < 0

    password = Array.new(length) { all_characters.sample }.join
    return password
  end

  def calculate_entropy(password)
    include_lowercase = password.match?(/[a-z]/)
    include_uppercase = password.match?(/[A-Z]/)
    include_numbers = password.match?(/\d/)
    include_specials = password.match?(/[!@#$%^&*()\-_+=\[\]{}|;:'",.<>\/?`~]/)

    alphabet_size = 0
    alphabet_size += 26 if include_lowercase
    alphabet_size += 26 if include_uppercase
    alphabet_size += 10 if include_numbers
    alphabet_size += 32 if include_specials

    return { entropy: 0, alphabet_size: 0 } if alphabet_size.zero?

    password_length = password.length
    entropy = password_length * Math.log2(alphabet_size)

    { entropy: entropy.round(1), alphabet_size: alphabet_size }
  end
end
