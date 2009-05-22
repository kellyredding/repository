module Repository
  class FileSystem

    # all path designations should be passed as arrays, where each array element corresponds to a path segment
    # the class handles joining the segments with the appropriate seperator
  
    # you should override ROOT appropriately, depending on where you want your repo located
    ROOT ||= '/'
    WRITE = "w"
    READ = "r"
    
    # Return the array of the repository root
    def self.root_array
      ROOT.split(File::SEPARATOR)
    end
    
    # Return the full file system path of the given directory or file
    def self.sys_path_array(rep_path = [])
      self.root_array+rep_path
    end
    
    # Return the full file system path of the given directory or file
    def self.sys_path(rep_path = [])
      sys_path_array(rep_path).join(File::SEPARATOR)
    end
    
    # Read the file data specified by the given path
    def self.read(rep_path)
      File.open(self.sys_path(rep_path), READ) { |file| yield file.read }
    end
    
    # Delete a file at the given path in the repository
    def self.delete(rep_path)
      File.delete(self.sys_path(rep_path)) if self.exists?(rep_path)
    end
    
    # Change the permission of a file
    def self.chmod(rep_path, permission)
      File.chmod(permission, self.sys_path(rep_path))
    end
    
    # Return whether a path exists or not
    def self.exists?(rep_path)
     File.exists?(self.sys_path(rep_path))
    end
    
    # Writes file data to the given path
    def self.write(data, file_rep_path)
      File.open(self.sys_path(file_rep_path), WRITE) { |file| file.write(data) }      
    end
  
    # Create the specified directory and any parent dirs in the root
    def self.mkdir(rep_dir, permission=0777)
      FileUtils.makedirs(self.sys_path(rep_dir))
      FileUtils.chmod(permission, self.sys_path(rep_dir))
      rep_dir
    end
    
    # Copy the file from param1 to location specified in param2
    def self.cp(from_rep_path, to_rep_path)
      FileUtils.cp(self.sys_path(from_rep_path), self.sys_path(to_rep_path))
    end
    
    # Same as cp except recrusive
    def self.cpdir(from_rep_path, to_rep_path)
      FileUtils.cp_r(self.sys_path(from_rep_path), self.sys_path(to_rep_path))
    end
    
    # Delete the specified directory and contents in the root
    def self.rmdir(rep_dir)
      sys_path = self.sys_path(rep_dir)
      if File.exists?(sys_path)
        Dir.foreach(sys_path) {|file_name| File.delete(self.sys_path(rep_dir+[file_name])) if !File.directory?(self.sys_path(rep_dir+[file_name])) }
        Dir.delete(sys_path)
      end
      rep_dir
    end

    # Return the filtered contents of a directory in an array
    def self.directory_contents(rep_path, filter = '*')
      Dir[self.sys_path(rep_path+[filter])]
    end
    
  end
   
end
