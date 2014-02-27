require "copy_carrierwave_file/version"
require "copy_carrierwave_file/copy_file_service"

module CopyCarrierwaveFile
  def copy_carrierwave_file(original_resource, destination_resource, mount_point)
    CopyCarrierwaveFile::CopyFileService.new(original_resource, destination_resource, mount_point, false).set_file
  end

  def copy_carrierwave_versions(original_resource, destination_resource, mount_point)
    CopyCarrierwaveFile::CopyFileService.new(original_resource, destination_resource, mount_point, true)

    # versions.each do |version|
      # logger.debug version
      # CopyCarrierwaveFile::CopyFileService.new(original_resource, destination_resource, mount_point, version).set_file
    # end
  end
end
