require_relative "../models/address_book.rb"

class MenuController
    attr_accessor :address_book

    def initialize
        @address_book = AddressBook.new
    end

    def main_menu

        puts "Main Menu - #{@address_book.entries.count} entries"
        puts "1 - View all entries"
        puts "2 - View Entry Number n"
        puts "3 - Create an entry"
        puts "4 - Search for an entry"
        puts "5 - Import entries from a CSV"
        puts "6 - Nuke (delete) all entries"
        puts "7 - Exit"
        print "Enter your selection: "


        selection = gets.to_i
        puts "You picked #{selection}"

        case selection
            when 1
            system "clear"
            view_all_entries
            main_menu
            when 2
            system "clear"
            view_entry_number
            main_menu
            when 3
            system "clear"
            create_entry
            main_menu
            when 4
            system "clear"
            search_entries
            main_menu
            when 5
            system "clear"
            read_csv
            main_menu
            when 6
            system "clear"
            nuke_entries
            main_menu
            when 7
            puts "Good-bye!"

            exit(0)

            else
            system "clear"
            puts "Sorry, that is not a valid input"
            main_menu
        end
    end


        def view_all_entries
            @address_book.entries.each do |entry|
                system "clear"
                puts entry.to_s

                entry_submenu(entry)
            end

            system "clear"
            puts "End of entries"
        end

        def view_entry_number
            print "Entry number to view: "

                selection = gets.chomp.to_i

                if selection < @address_book.entries.count
                  puts @address_book.entries[selection]
                  puts "Press enter to return to the main menu"
                  gets.chomp
                  system "clear"
                else
                  puts "#{selection} is not a valid input"
                  view_entry_number
                end
        end

        def delete_entry(entry)
          @address_book.entries.delete(entry)
          puts "#{entry.name} has been deleted"
        end

        def edit_entry(entry)
          #perform a series of print statements followed by gets.chomp assignment statements. Each gets.chomp statement gathers user input and assigns it to an appropriately named variable.
          print "Update name: "
          name = gets.chomp
          print "Updated phone number: "
          phone_number = gets.chomp
          print "Updated email: "
          email = gets.chomp
          #use !attribute.empty? to set attributes on entry only if a valid attribute was read from user input.
          entry.name = name if !name.empty?
          entry.phone_number = phone_number if !phone_number.empty?
          entry.email = email if !email.empty?
          system "clear"
          #print out entry with the updated attributes.
          puts "Updated entry:"
          puts entry
        end


        def nuke_entries
          puts "Would you really like to delete all entries?"
          puts "(yes or no)"
          input = gets.chomp

          if input == "yes"
            @address_book.delete_all_entries
            puts "Your loss!"
          else
            puts "Phew, that was close!"
            main_menu
          end
        end



        def create_entry
            system "clear"
            puts "New AddressBloc Entry"

            print "Name: "
            name = gets.chomp
            print "Phone number: "
            phone = gets.chomp
            print "Email: "
            email = gets.chomp


            @address_book.add_entry(name, phone, email)

            system "clear"
            puts "New entry created"
        end

        def search_entries
          #get the name that the user wants to search for and store it in name.
          print "Search by name: "
          name = gets.chomp
          #call search on address_book which will either return a match or nil, it will never return an empty string since import_from_csv will fail if an entry does not have a name.
          match = @address_book.binary_search(name)
          system "clear"
          #check if search returned a match. This expression evaluates to false if search returns nil since nil evaluates to false in Ruby.
          #If search finds a match then we call a helper method called search_submenu. search_submenu displays a list of operations that can be performed on an Entry.
          if match
            puts match.to_s
            search_submenu(match)
          else
            puts "No match found for #{name}"
          end
        end


        def read_csv
          #prompt the user to enter a name of a CSV file to import.
          print "Enter CSV file to import: "
          file_name = gets.chomp
          #check to see if the file name is empty.
          if file_name.empty?
            system "clear"
            puts "No CSV file read"
            main_menu
          end
          #import the specified file with import_from_csv on address_book. We then clear the screen and print the number of entries that were read from the file. All of these commands are wrapped in a begin/rescue block. begin will protect the program from crashing if an exception is thrown.
          begin
            entry_count = @address_book.import_from_csv(file_name).count
            system "clear"
            puts "#{entry_count} new entries added from #{file_name}"
          rescue
            puts "#{file_name} is not a valid CSV file, please enter the name of a valid CSV file}"
            read_csv
          end
        end
      end



          def entry_submenu(entry)
            puts "n - next entry"
            puts "d - delete entry"
            puts "e - edit this entry"
            puts "m - return to main menu"

            selection = $stdin.gets.chomp

            case selection
            when "n"
            when "d"
              #when a user is viewing the submenu and they press d, we call delete_entry. After the entry is deleted, control will return to view_all_entries and the next entry will be displayed.
              delete_entry(entry)
            when "e"
              #call edit_entry when a user presses e. We then display a sub-menu with entry_submenu for the entry under edit.
              edit_entry(entry)
              entry_submenu(entry)
            when "m"
              system "clear"
              main_menu
            else
              system "clear"
              puts "#{selection} is not a valid input"
              entry_submenu(entry)
            end
          end

        def search_submenu(entry)
          #print out the submenu for an entry.
          puts "d - delete_entry"
          puts "e - edit this entry"
          puts "m - return to main menu"
          #save the user input to selection.
          selection = gets.chomp
          #use a case statement and take a specific action based on user input. If the user input is d we call delete_entry and after it returns we call main_menu.
          #If the input is e we call edit_entry. m will return the user to the main menu. If the input does not match anything (see the else statement) then we clear the screen and ask for their input again by calling search_submenu.
          case selection
          when "d"
            system "clear"
            delete_entry(entry)
            main_menu
          when "e"
            edit_entry(entry)
            system "clear"
            main_menu
          when "m"
            system "clear"
            main_menu
          else
            system "clear"
            puts "#{selection} is not a valid input"
            puts entry.to_s
            search_submenu(entry)
          end
        end
