require_relative "entry.rb"

class AddressBook
    attr_accessor :entries
    
    def initialize
        @entries = []
    end
    
    def add_entry(name, phone, email)
        index = 0
        @entries.each do |entry|
            if name < entry.name
                break
            end
            index += 1
        end
        @entries.insert(index, Entry.new(name, phone, email))
    end
    
    def remove_entry(name, phone, email)
        index = 1
        @entries.each do |entry|
            if @entries == entry.name
                entry.delete
            end
        end
        index = 0
    end
    
    def view_entry_number(index)
            if index >= 0 && index < entries.size
              return entries[index]
            else
              system "clear"
              puts "The number you selected is not valid"
            end
      end
end