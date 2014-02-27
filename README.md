# CopyCarrierwaveFile


Simple gem for copying [CarrierWave](https://github.com/carrierwaveuploader/carrierwave) files between resources.
It's solving issues with local and remote storage discussed
[here](http://stackoverflow.com/questions/9921085/whats-the-proper-way-to-copy-a-carrierwave-file-from-one-record-to-another)


## Installation

Add this line to your application's Gemfile:

    gem 'copy_carrierwave_file', github: 'equivalent/copy_carrierwave_file'

And then execute:

    $ bundle


## Usage

You can use service class directly:

    original_resource = User.last
    new_resource      = User.new

    CopyCarrierwaveFile::CopyFileService.new(original_resource, new_resource, :avatar).set_file
      # :avatar represents mount point

    new_resource.save

or you can include `CopyCarrierwaveFile` module and call `copy_carrierwave_file` :


    class Document
      include CopyCarrierwaveFile
      mount_uplader :content_file, MyUploader

      def duplicate_file(original)
        copy_carrierwave_file(original, self, :content_file)
        self.save!
      end
    end

    document = Document.new
    document.duplicate_file(Document.last)

Functionality is the same

Also you can copy all file versions after save the record like so:

    class Document
      include CopyCarrierwaveFile
      mount_uplader :content_file, MyUploader

      def duplicate_file(original)
        copy_carrierwave_file(original, self, :content_file)
        self.save!
        copy_carrierwave_versions(original, self, :image)
      end
    end

    document = Document.new
    document.duplicate_file_and_versions(Document.last)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
