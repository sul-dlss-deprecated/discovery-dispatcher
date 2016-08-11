require 'rails_helper'

describe PurlFetcher::API do
  let(:client) { instance_double(PurlFetcher::Client) }
  describe '#changes' do
    it 'passes the params off to PurlFetcher::Client#paginated_get' do
      expect(subject).to receive(:client).and_return(client)
      expect(client).to receive(:paginated_get).with('/docs/changes', 'changes', page: 4)
      subject.changes(page: 4)
    end
  end
  describe '#deletes' do
    it 'passes the params off to PurlFetcher::Client#paginated_get' do
      expect(subject).to receive(:client).and_return(client)
      expect(client).to receive(:paginated_get).with('/docs/deletes', 'deletes', page: 4)
      subject.deletes(page: 4)
    end
  end
end
