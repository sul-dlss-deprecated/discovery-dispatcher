require 'rails_helper'

describe PurlFetcher::Client do
  let(:connection) { instance_double(Faraday::Connection) }
  describe '#get' do
    it 'sends get to the connection and parses the response body' do
      expect(connection).to receive(:get).with('/yolo')
        .and_return(instance_double(Faraday::Response, body: 'You only live once!'))
      expect(subject).to receive(:connection).and_return(connection)
      expect(subject.get('/yolo')).to eq 'You only live once!'
    end
  end
  describe '#paginated_get' do
    let(:response_1) do
      {
        "docs": Array(1..100),
        "pages": {
          "next_page": 2,
          "last_page?": false
        }
      }.to_json
    end
    let(:response_2) do
      {
        "docs": Array(101..200),
        "pages": {
          "next_page": 3,
          "last_page?": false
        }
      }.to_json
    end
    let(:response_3) do
      {
        "docs": Array(201..300),
        "pages": {
          "next_page": nil,
          "last_page?": true
        }
      }.to_json
    end
    it 'returns an Enumerator' do
      expect(subject.paginated_get('/yolo', 'docs')).to be_an Enumerator
    end
    it 'creates a paginated response' do
      expect(subject).to receive(:get).with('/yolo', page: 1, per_page: 100)
        .twice.and_return(JSON.parse(response_1))
      expect(subject).to receive(:get).with('/yolo', page: 2, per_page: 100)
        .twice.and_return(JSON.parse(response_2))
      expect(subject).to receive(:get).with('/yolo', page: 3, per_page: 100)
        .twice.and_return(JSON.parse(response_3))
      subject.paginated_get('/yolo', 'docs').each_with_index do |doc, i|
        expect(doc).to eq i + 1
      end
      expect(subject.paginated_get('/yolo', 'docs').count).to eq 300
    end
  end
end
