def get_command_line_argument
    # ARGV is an array that Ruby defines for us,
    # which contains all the arguments we passed to it
    # when invoking the script from the command line.
    # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
    if ARGV.empty?
      puts "Usage: ruby lookup.rb <domain>"
      exit
    end
    ARGV.first
  end

  # `domain` contains the domain name we have to look up.
  domain = get_command_line_argument

  # File.readlines reads a file and returns an
  # array of string, where each element is a line
  # https://www.rubydoc.info/stdlib/core/IO:readlines
  dns_raw = File.readlines("zone")
  # ..
  # ..
  # FILL YOUR CODE HERE
  def parse_dns(dns_raw)

    dns_raw1 = []
    len = dns_raw.length-1
    i = 0
    for r in 0..len do
          str1 = dns_raw[r]
          if dns_raw[r][0] != '#'
            dns_raw1[i] = dns_raw[r]
            i = i + 1
          end
    end
    dns_raw = dns_raw1

     b=[]
     dns_raw.each do |item|
          str =  item == "\n"
          if !str
            b.push(item.split(','))
          end
      end

      len = b.length-1
      dns_records ={}

      for r in 0 .. len do
          dkey = {}
          dkey[:type] = b[r][0].strip
          dkey[:target] = b[r][2].strip.chomp
          dns_records[b[r][1].strip] = dkey
      end

    return dns_records
  end

  def resolve(dns_records, lookup_chain, domain)

      record = dns_records[domain]

      if (!record)
        lookup_chain=[]
        lookup_chain.push("Error: Record not found for "+domain)
      elsif record[:type] == "CNAME"
        domain = record[:target]
        lookup_chain.push(record[:target])
        resolve(dns_records,lookup_chain,domain)
      elsif record[:type] == "A"
        domain = record[:target]
        lookup_chain.push(record[:target])
      else
        lookup_chain=[]
        lookup_chain.push("Invalid record type for "+domain)
     end
  end

  # ..
  # ..

  # To complete the assignment, implement `parse_dns` and `resolve`.
  # Remember to implement them above this line since in Ruby
  # you can invoke a function only after it is defined.
  dns_records = parse_dns(dns_raw)
  lookup_chain = [domain]
  lookup_chain = resolve(dns_records, lookup_chain, domain)
  puts lookup_chain.join(" => ")
