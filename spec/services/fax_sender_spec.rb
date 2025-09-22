require "rails_helper"

RSpec.describe FaxSender do
  let(:file_path) { Rails.root.join("tmp", "test_fax.txt").to_s }
  let(:receiver_number) { "1234567890" }
  let(:token) { "test-token" }
  let(:mock_client) { double("HttpClient") }

  subject do
    described_class.new(file_path, receiver_number: receiver_number, token: token, http_client: mock_client)
  end

  before do
    File.write(file_path, "Test fax content")
  end

  after do
    File.delete(file_path) if File.exist?(file_path)
  end

  it "returns JSON response on 201" do
    response = double("Response", code: 201, body: '{"fax_id":"abc123"}')

    expect(mock_client).to receive(:post).with(
      "/faxes",
      hash_including(
        headers: {"Authorization" => "Bearer #{token}"},
        body: hash_including(:receiver_number, :file),
        timeout: 10
      )
    ).and_return(response)

    result = subject.call
    expect(result).to eq({"fax_id" => "abc123"})
  end

  it "raises if file is missing" do
    File.delete(file_path)

    expect { subject.call }.to raise_error(ArgumentError, /File not found/)
  end
end
