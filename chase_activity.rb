require 'date'

class ChaseActivity
  attr_accessor :donation_date, :member_name, :amount

  def initialize(donation_date, member_name, amount)
    # Instance variables
    @donation_date = Date::strptime(donation_date, "%m/%d/%Y")
    @member_name = process_name(member_name)
    @amount = amount
  end

  def process_name(member_name)
    name = member_name.split(", ")
    if name.length == 2
      return name.reverse.join(" ")
    else
      return member_name
    end
  end

  def to_s
    @donation_date.strftime("%m/%d/%Y") + "|" +  @member_name + "|" +  @amount.to_s
  end
end


class QuickpayActivity
  attr_accessor :donation_date, :member_name, :description, :amount

  def initialize(donation_date, member_name, description, amount)
    # Instance variables
    @donation_date = Date::strptime(donation_date, "%b %d, %Y")
    @member_name = process_name(member_name)
    @description = description
    @amount = amount.gsub(/[^\d\.]/, '')
  end

  def process_name(member_name)
    name = member_name.split(", ")
    if name.length == 2
      return name.reverse.join(" ")
    else
      return member_name
    end
  end

  def to_s
    @donation_date.strftime("%m/%d/%Y") + ',' +  @member_name + ',"' + (@description || " ") + '",' + @amount
  end
end
