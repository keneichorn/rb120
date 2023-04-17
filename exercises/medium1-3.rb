class Student
  def initialize(name, year)
    @name = name
    @year = year
  end
end

class Graduate < Student
  def initialize(name, year, parking)
    super(name, year)
    @parking = parking
  end
end

class Undergraduate < Student
end

becca = Undergraduate.new("becca", 2023)
nevil = Graduate.new("nevil", 2023, "35b")
p becca
p nevil