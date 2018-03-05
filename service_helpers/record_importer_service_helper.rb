class RecordImporterServiceHelper

  CONN_TIMEOUT = 10
  WEBSERVICE_URL = https://sampledomain.com/create
  EXAMPLE_XML_ERB = File.expand_path("/request.xml.erb").freeze
  DEFAULT_WEB_SERVICE_URL_OPTIONS = {
      host: "services.example",
      protocol: 'https'
  }.freeze

  class << self

    def create_record(headers: {content_type: :xml}, username: 'user1', password: 'pass123',vin:)
      response = RestClient::Request.execute(method: :post,
                                             timeout: CONN_TIMEOUT,
                                             url: WEBSERVICE_URL,
                                             headers: headers,
                                             user: username,
                                             password: password,
                                             payload: create_record_payload(vin))
      Nokogiri::XML(response).xpath('//record/id').text
    rescue => e
      puts e.response
      raise
    end

    def update_record(headers: {content_type: :xml}, username: 'user1', password: 'pass123', update_payload:)
      response = RestClient::Request.execute(method: :post,
                                             timeout: CONN_TIMEOUT,
                                             url: WEBSERVICE_URL,
                                             headers: headers,
                                             user: username,
                                             password: password,
                                             payload: update_payload)
      Nokogiri::XML(response).xpath('//record/id').text
    rescue => e
      puts e.response
      raise
    end

    def delete_record(headers: {content_type: :xml}, username: 'user1', password: 'pass123', record_id:)
      response = RestClient::Request.execute(method: :post,
                                             timeout: CONN_TIMEOUT,
                                             url: WEBSERVICE_URL,
                                             headers: headers,
                                             user: username,
                                             password: password,
                                             payload: delete_record_payload(vin))
      Nokogiri::XML(response).xpath('//status').text == "Deleted"
    rescue => e
      puts e.response
      raise
    end

    private

    def create_record_payload(vin)
      params_object = OpenStruct.new(
          vin: vin,
          account_id: 12345,
          start_time: Time.now,
          end_time: 5.minutes.from_now,
          allow_param: 1,
          contact_name: 'Test Team',
          contact_email: 'default@gmail.com',
          buy_price: 30000)
      erb = ERB.new(File.read(EXAMPLE_XML_ERB)).tap { |e| e.filename = EXAMPLE_XML_ERB }
      erb.result(params_object.__binding__)
    end

    def delete_record_payload(record_id)
      <<~XML
        <record>
          <id>#{record_id}</id>
          <reason>test</reason>
        </record>
      XML
    end
  end
end
