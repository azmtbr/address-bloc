require_relative "entry.rb"
require "csv"

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

    def import_from_csv(file_name)
      csv_text = File.read(file_name)
     csv = CSV.parse(csv_text, headers: true, skip_blanks: true)

     csv.each do |row|
       row_hash = row.to_hash
       add_entry(row_hash["name"], row_hash["phone_number"], row_hash["email"])
     end

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

    def binary_search(name)
      #save the index of the leftmost item in the array in a variable named lower, and the index of rightmost item in the array in upper. If we think of the array in terms of left-to-right where the leftmost item is the zeroth index and the rightmost item is the entries.length-1 index.
      lower = 0
      upper = entries.length - 1

     #we loop while our lower index is less than or equal to our upper index.
     while lower <= upper
     #we find the middle index by taking the sum of lower and upper and dividing it by two. Ruby will truncate any decimal numbers, so if upper is five and lower is zero then mid will get set to two. Then we retrieve the name of the entry at the middle index and store it in mid_name.
       mid = (lower + upper) / 2
       mid_name = entries[mid].name

     #we compare the name that we are searching for, name, to the name of the middle index, mid_name. Take note that we are using the == operator when comparing the names which makes the search case sensitive
       if name == mid_name
         return entries[mid]
       elsif name < mid_name
         upper = mid - 1
       elsif name > mid_name
         lower = mid + 1
       end
     end
     #if we divide and conquer to the point where no match is found, we simply return nil.
     return nil
    end

end
