module CopyCarrierwaveFile
  class CopyFileService
    attr_reader :original_resource, :resource, :mount_point, :versions

    def initialize(original_resource, resource, mount_point, versions)
      @mount_point       = mount_point.to_sym

      raise "#{original_resource} is not a resource with uploader" unless original_resource.class.respond_to? :uploaders
      raise "#{original_resource} doesn't have mount point #{mount_point}" unless original_resource.class.uploaders[@mount_point]

      raise "#{resource} is not a resource with uploader" unless resource.class.respond_to? :uploaders
      raise "#{resource} doesn't have mount point #{mount_point}" unless resource.class.uploaders[@mount_point]

      @original_resource = original_resource
      @resource          = resource

      if versions == true
        @original_resource.class.uploaders[@mount_point].versions.each do |version|
          set_version(version.first)
        end
      end
    end

    # Set file from original resource
    #
    # Founded originally at http://bit.ly/ROGtPR
    #
    def set_file
      if have_file?
        begin
          set_file_for_remote_storage
        rescue Errno::ENOENT
          set_file_for_local_storage
        rescue NoMethodError
          raise "Original resource has no File"
        end
      else
        raise "Original resource has no File"
      end
    end

    def set_version(version)
      if have_version?(version)
        begin
          set_version_for_remote_storage(version)
        rescue Errno::ENOENT
          set_version_for_local_storage(version)
        rescue NoMethodError
          raise "Original resource has no File"
        end
      else
        raise "Original resource has no File"
      end
    end

    def have_file?
      original_resource_mounter.url.present?
    end

    def have_version?(version)
      version_mounter(version).present?
    end

    # Set file when you use remote storage for your files (like S3)
    #
    # will try to fetch full remote path of a file with `open-uri`
    #
    # If you use local storage, `doc.avatar.url` will return relative path, therefor
    # this will fail with Errno::ENOENT
    #
    # If you have issues with code try alternative code:
    #
    #    resource.remote_file_url = original_resource.avatar.url
    #
    def set_file_for_remote_storage
      set_resource_mounter_file open(original_resource_mounter.url)
    end

    def set_version_for_remote_storage(version)
      copy_version open(version_mounter(version).file.file)
    end

    def set_file_for_local_storage
      set_resource_mounter_file File.open(original_resource_mounter.file.file)
    end

    def set_version_for_local_storage(version)
      copy_version File.open(version_mounter(version).file.file)
    end

    def original_resource_mounter
      original_resource.send(mount_point)
    end

    def version_mounter(version)
      original_resource.image.send("#{version}")
    end

    def set_resource_mounter_file(file)
      resource.send( :"#{mount_point.to_s}=", file)
    end

    def copy_version(file)
      file_copy = CarrierWave::SanitizedFile.new(file)
      file_copy.copy_to(resource.image.path.sub(/^(.*\/)([^\/]*)$/, '\\1'))
    end

  end
end
