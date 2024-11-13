class PagesController < ApplicationController
  def password
    length = params[:length].to_i
    include_symbols = params[:include_symbols] == '1'
    include_numbers = params[:include_numbers] == '1'
    @password = generate_password(length, include_symbols, include_numbers)

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

    Array.new(length) { all_characters.sample }.join
  end
end
