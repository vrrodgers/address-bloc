require_relative '../models/address_book'
class MenuController
  attr_reader :address_book

  def initialize
    @address_book = AddressBook.new
    @menu_options = { 
                        "1": "View all entries",
                        "2": "Create an entry",
                        "3": "Search for an entry",
                        "4": "Import entries from a CSV",
                        "5": "View Entry Number",
                        "6": "Exit"
                        
                    }
  end
  
  
  def main_menu
    puts "Main Menu - #{address_book.entries.count} entries"
    @menu_options.each do |key, value|
        puts "#{key} -  #{value}"
    end
    print "Enter your selection: "

        selection = gets.to_i

        case selection
        when 1
            system "clear"
            view_all_entries
            main_menu
        when 2
            system "clear"
            create_entry
            main_menu
        when 3
            system "clear"
            search_entries
            view_entry_by_number 
            main_menu
        when 4
            system "clear"
            read_csv
            main_menu

        when 5
            system "clear"
            view_entry_by_number
            main_menu  
        when 6
            puts "Good-bye!"
            # #8
            exit(0)
        # #9
        else
            system "clear"
            puts "Sorry, that is not a valid input"
            main_menu
        end   
        
    end    

   def add_menu_option
        puts "Enter new menu option"
        @option = gets.chomp 
        puts "Enter new entry number"
        @key = gets.chomp 
        while @key.to_i < @menu_options.length + 1
            puts "The entry number aleady exist" 
            puts "Please enter a valid entry number #{@menu_options.length}"
            @key = gets.chomp
        end
        @menu_options[@key] = @option 
    end

   def view_all_entries
      address_book.entries.each do |entry|
        system "clear"
        puts entry.to_s
        entry_submenu(entry)
      end
      system "clear"
      puts "End of entries"
    end

    def view_entry_by_number
        
       puts  "What number would you like to view? Please note that the entries start with number 1"
        n = gets.chomp.to_i
       
        if @address_book.entries.any?
            if @address_book.entries[n - 1] != nil
                puts @address_book.entries[n - 1]
            else
                puts "Invalid entry"
                view_entry_by_number
            end
        else
            puts "Invalid entry"
            view_entry_by_number
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
        puts @address_book.entries.last
    end
 
   def search_entries
      print "Search by name: "
      name = gets.chomp
      match = address_book.binary_search(name)
      system "clear"

       if match
         puts match.to_s
         search_submenu(match)
        else
          puts "No match found for #{name}"
        end
    end
 
   def read_csv
     print "Enter CSV file to import: "
     file_name = gets.chomp
      if file_name.empty?
        system "clear"
        puts "No CSV file read"
        main_menu
      end
      begin
       entry_count = address_book.import_from_csv(file_name).count
       system "clear"
       puts "#{entry_count} new entries added from #{file_name}"
     rescue
       puts "#{file_name} is not a valid CSV file, please enter the name of a valid CSV file"
       read_csv
      end 
    end

    def entry_submenu(entry)
        puts "n - next entry"
        puts "d - delete entry"
        puts "e - edit this entry"
        puts "m - return to main menu"

       selection = gets.chomp
 
        case selection
        when "n"
           system "clear"
          

        when "d"
            delete_entry(entry)

        when "e"
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
    def delete_entry(entry)
     address_book.entries.delete(entry)
     puts "#{entry.name} has been deleted"
   end
   def edit_entry(entry)
        print "Updated name: "
        name = gets.chomp
        print "Updated phone number: "
        phone_number = gets.chomp
        print "Updated email: "
        email = gets.chomp
        
        entry.name = name if !name.empty?
        entry.phone_number = phone_number if !phone_number.empty?
        entry.email = email if !email.empty?
        system "clear"
        puts "Updated entry:"
        puts entry
   end
   def search_submenu(entry)
       puts "\nd - delete entry"
       puts "e - edit this entry"
       puts "m - return to main menu"

       selection = gets.chomp
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
end   