module Repository
  class FileSystem
    module Helpers
      FILE_SIZE_ABBREVS = ['Bytes', 'KB', 'MB', 'GB']

      def abbrev_file_size(size_in_bytes)
        value = size_in_bytes
        FILE_SIZE_ABBREVS.each do |abbrev|
          return value.to_s + ' ' + abbrev if value < 1000 || abbrev == FILE_SIZE_ABBREVS.last
          value /= 1000
        end
      end

      def full_file_name=(full_name)
        self.extension = File.extname(full_name).downcase.chomp if new_record?
        self.file_name = clean_file_name(full_name)
      end

      def clean_file_name(file_name)
        File.basename(file_name,'.*').gsub(/\s+/,'_').gsub(/_+/,'_').gsub(/[^\w._-]/,'').chomp
      end
    end
  end
end