# frozen_string_literal: true
describe 'consumer can buy imported record' do
  context 'a record is imported via Record Imported Web Service' do
    let(:record) { ConsumerRecord.find_by(id: @record_id) }
    let(:logger) { Logger.new(Rails.root.join('log', 'e2e_test.log')) }

    before(:each) do
      @record_id = RecordImporterServiceHelper.create_record(vin: VinGenerator.generate_vin)
      logger.error("Error: record #{record.id} expected status Imported, actual status #{record.status}") unless record.status == Status::Imported
      logger.info("record Created with record_id: #{@record_id}")
    end

    it 'consumer successfully buys an imported record' do
      username = ENV['CONSUMER_USERNAME'] ||= 'user1'
      password = ENV['CONSUMER_PASSWORD'] ||= 'password'
      my_consumer_site.login_as(username, password)
      logger.info("Logged in as user: #{username}")
      my_consumer_site.go_to(:record_details, id: record.id)
      my_consumer_site.record_details_page.buy_now
      wait_for_update(record, 20)
      expect(record.buy_now.size).to eq 1
      logger.info("Purchase was successful")
    end

    after(:each) do
      RecordImporterServiceHelper.deactivate_record(record_id: record.id)
      logger.info("Record deactivated with record_id: #{@record_id}")
    end
  end
end