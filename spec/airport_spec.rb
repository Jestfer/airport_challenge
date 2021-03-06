require 'airport'

describe Airport do
  describe "#landing" do

    before do
      @plane = Plane.new
      subject.weather.condition = 'sunny'
    end

    it 'should instruct plane to land at the airport' do
      subject.land(@plane)

      expect(subject.hangar).to include(@plane)
    end

    it 'should not allow plane to land again if in hangar' do
      subject.land(@plane)

      expect(subject.hangar).to include(@plane)
      expect { subject.land(@plane) }.to raise_error("Already in hangar")
    end

    it 'should raise error when hangar capacity is exceeded' do
      airport = Airport.new(1)
      plane2 = Plane.new
      airport.weather.condition = 'sunny'

      airport.land(@plane)
      expect(airport.hangar).to include(@plane)

      expect { airport.land(plane2) }.to raise_error("Hangar is at its full capacity")
    end

    it 'should prevent landing when weather is stormy' do
      subject.weather.condition = 'stormy'

      expect { subject.land(@plane) }.to raise_error("Can't land due to stormy weather")
    end
  end

  describe "#take_off" do

    before do
      @plane = Plane.new
      subject.weather.condition = 'sunny'
      subject.land(@plane)
      subject.weather.condition = 'sunny'
    end

    it 'should instruct plane to take off' do
      subject.take_off(@plane)

      expect(subject.hangar).not_to include(@plane)
    end

    it 'should output plane is no longer at the airport' do
      expect(subject.take_off(@plane)).to eq "#{@plane} has just taken off"
    end

    it 'should raise error if plane takes off from wrong airport' do
      another_airport = Airport.new

      expect { another_airport.take_off(@plane) }.to raise_error("Plane not in hangar")
    end

    it 'should prevent takeoff when weather is stormy' do
      subject.weather.condition = 'stormy'

      expect { subject.take_off(@plane) }.to raise_error("Can't take off due to stormy weather")
    end
  end

  describe "#modification of capacity" do
    it 'should modify default capacity as needed for other airports' do
      massive_airport = Airport.new(302)

      expect(massive_airport.capacity).to eq 302
    end
  end
end
