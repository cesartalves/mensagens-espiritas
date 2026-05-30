class HomeController < ApplicationController
  def index
  end

  def subscribe
    ddi = params[:ddi].to_s.strip
    ddd = params[:ddd].to_s.strip
    number = params[:number].to_s.strip

    unless ddi.match?(/\A\d{1,3}\z/)
      redirect_to root_path, alert: "DDI inválido"
      return
    end

    unless ddd.match?(/\A\d{2}\z/)
      redirect_to root_path, alert: "DDD inválido"
      return
    end

    unless number.match?(/\A9\d{8}\z/)
      redirect_to root_path, alert: "Número de celular inválido"
      return
    end

    full_number = "#{ddi}#{ddd}#{number}"

    dynamodb = ::Aws::DynamoDB::Client.new(
      region: ENV['AWS_REGION'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    )

    response = dynamodb.put_item(
      table_name: 'numeros-projeto-espirita',
      item: {
        'number' => full_number
      }
    )

    redirect_to root_path, notice: "Número recebido: #{full_number}"
  end
end
