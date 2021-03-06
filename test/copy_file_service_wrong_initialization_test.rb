require 'test_helper'


class User
  # has no uploader
end

describe CopyCarrierwaveFile::CopyFileService, 'initialization' do

  context 'with resources with uploader and right mount point' do
    it "should not raise an error" do
      CopyCarrierwaveFile::CopyFileService.new(Document.new, Document.new, :file)
    end
  end

  context 'when original resources without uploader' do
    it "should raise an error" do
      proc{ CopyCarrierwaveFile::CopyFileService.new(User.new, Document.new, :file) }.
        must_raise RuntimeError
    end
  end


  context 'when resources without uploader' do
    it "should raise an error" do
      proc{ CopyCarrierwaveFile::CopyFileService.new(Document.new, User.new, :file) }.
        must_raise RuntimeError
    end
  end

  context 'with resources with uploader but wrong mount point' do
    it do
      proc{ CopyCarrierwaveFile::CopyFileService.new(Document.new, Document.new, :foo) }.
        must_raise RuntimeError
    end
  end


end
