# frozen_string_literal: true
describe 'Record Importer Webservice' do
  context 'create or update a record' do

    let(:vin) {VinGenerator.generate_vin}
    let(:record) { ConsumerRecord.find_by(id: @record_id) }
    let(:updated_record) {}
    let(:update_payload_xml) { '<<~XML
        <record>
          <id>#{record_id}</id>
          <reason>updated</reason>
        </record>
      XML'}

    before(:each) do
      @record_id = RecordImporterServiceHelper.create_record(vin: VinGenerator.generate_vin)
    end

    it 'creates a record' do
      expect(record.status).to eq(Status::Imported)
    end

    it 'updates a record' do
      RecordImporterServiceHelper.update_record(record_id: record.id, update_payload: update_payload_xml)
      updated_record = ConsumerRecord.find_by(id: record.id)
      expect(updated_record.reason).to eq('updated')
    end

    after(:each) do
      RecordImporterServiceHelper.delete_record(record_id: record.id)
    end

  end
end