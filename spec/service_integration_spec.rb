# frozen_string_literal: true
describe 'Record Importer Webservice' do
  context 'create or update a record' do

    let(:vin) {VinGenerator.generate_vin}
    let(:record) { ConsumerRecord.find_by(id: @record_id) }

    before(:each) do
      @record_id = RecordImporterServiceHelper.create_record(vin: VinGenerator.generate_vin)
    end

    it 'creates a record' do
      expect(record.status).to eq(Status::Imported)

    end

    it 'updates a record' do

      update_payload_xml = <<~XML
        <record>
          <id>#{record_id}</id>
          <reason>test</reason>
        </record>
      XML

      RecordImporterServiceHelper.create_record(record_id: record.id, uodate_payload:  )

    end

    after(:each) do
      RecordImporterServiceHelper.delete_record(record_id: record.id)
    end

  end
end