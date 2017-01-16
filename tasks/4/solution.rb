VERSIONS = ['1.1', '1.1.1', '1.1.2', '1.1.3', '1.1.4']

RSpec.describe 'Version' do
  describe "#initialize" do
    it "initializes with no arguments" do
      expect(Version.new).to eq Version.new('0')
    end
    it "initializes with an empty string" do
      expect(Version.new('')).to eq Version.new('0')
    end
    it "fails when version starts with a dot" do
      expect { Version.new('.1') }.to(
        raise_error(ArgumentError, "Invalid version string '.1'")
      )
    end
    it "fails when version ends with a dot" do
      expect { Version.new('1.2.') }.to(
        raise_error(ArgumentError, "Invalid version string '1.2.'")
      )
    end
    it "fails when version contains letters" do
      expect { Version.new('v1.2') }.to(
        raise_error(ArgumentError, "Invalid version string 'v1.2'")
      )
    end
    it "fails when version contains two dots without a number between" do
      expect { Version.new('1..2') }.to(
        raise_error(ArgumentError, "Invalid version string '1..2'")
      )
    end
    it "fails when version contains negative numbers" do
      expect { Version.new('1.-2') }.to(
        raise_error(ArgumentError, "Invalid version string '1.-2'")
      )
      expect { Version.new('-1.2') }.to(
        raise_error(ArgumentError, "Invalid version string '-1.2'")
      )
    end
    it "initializes with another instance of the class" do
      expect(Version.new(Version.new('0.42')).to_s).to eq '0.42'
    end
  end

  describe "#to_s" do
    it "renders the canonical representation of the version" do
      expect(Version.new('1.2.0').to_s).to eq '1.2'
      expect(Version.new('1.2.0.0').to_s).to eq '1.2'
      expect(Version.new('0.0').to_s).to eq ''
    end
  end

  def test_inequality_both_ways(version1, method, version2)
    expect(version1.public_send(method, version2)).to be true
    expect(version2.public_send(method, version1)).to be false
  end

  describe "#>" do
    it "compares correctly in the basic cases" do
      test_inequality_both_ways Version.new('1.2'), '>', Version.new('0.2')
      test_inequality_both_ways Version.new('1.2'), '>', Version.new('1.1')
      test_inequality_both_ways Version.new('1.3.2'), '>', Version.new('1.2.5')
    end
    it "compares correctly when versions have different lengths" do
      test_inequality_both_ways Version.new('1.2.3'), '>', Version.new('1.2')
    end
  end

  describe "#>=" do
    it "compares correctly when the versions are differnt" do
      test_inequality_both_ways Version.new('1.2'), '>=', Version.new('0.2')
      test_inequality_both_ways Version.new('1.2'), '>=', Version.new('1.1')
      test_inequality_both_ways Version.new('1.3.2'), '>=', Version.new('1.2.5')
    end
    it "compares correctly when the versions are the same" do
      expect(Version.new('0')).to be >= Version.new('0')
      expect(Version.new('1')).to be >= Version.new('1')
      expect(Version.new('1.2.3')).to be >= Version.new('1.2.3')
    end
    it "compares correctly when versions have different lengths" do
      test_inequality_both_ways Version.new('1.2.3'), '>=', Version.new('1.2')
      expect(Version.new('1.2.0')).to be >= Version.new('1.2')
      expect(Version.new('1.2')).to be >= Version.new('1.2.0')
    end
  end

  describe "#<" do
    it "compares correctly in the basic cases" do
      test_inequality_both_ways Version.new('0.2'), '<', Version.new('1.2')
      test_inequality_both_ways Version.new('1.1'), '<', Version.new('1.2')
      test_inequality_both_ways Version.new('1.2.5'), '<', Version.new('1.3.2')
    end
    it "compares correctly when versions have different lengths" do
      test_inequality_both_ways Version.new('1.2'), '<', Version.new('1.2.3')
    end
  end

  describe "#<=" do
    it "compares correctly when the versions are differnt" do
      test_inequality_both_ways Version.new('0.2'), '<=', Version.new('1.2')
      test_inequality_both_ways Version.new('1.1'), '<=', Version.new('1.2')
      test_inequality_both_ways Version.new('1.2.5'), '<=', Version.new('1.3.2')
    end
    it "compares correctly when the versions are the same" do
      expect(Version.new('0')).to be <= Version.new('0')
      expect(Version.new('1')).to be <= Version.new('1')
      expect(Version.new('1.2.3')).to be <= Version.new('1.2.3')
    end
    it "compares correctly when versions have different lengths" do
      test_inequality_both_ways Version.new('1.2'), '<=', Version.new('1.2.3')
      expect(Version.new('1.2.0')).to be <= Version.new('1.2')
      expect(Version.new('1.2')).to be <= Version.new('1.2.0')
    end
  end

  describe "#==" do
    it "compares correctly versions of equal length" do
      expect(Version.new('0')).to be == Version.new('0')
      expect(Version.new('1')).to be == Version.new('1')
      expect(Version.new('1.2.3')).to be == Version.new('1.2.3')
      expect(Version.new('0')).to_not be == Version.new('1')
      expect(Version.new('1.2.3')).to_not be == Version.new('1.3.2')
    end
    it "compares correctly versions of different lengths" do
      expect(Version.new('1.2')).to be == Version.new('1.2.0')
      expect(Version.new('0.1')).to_not be == Version.new('1')
      expect(Version.new('1.2.0')).to_not be == Version.new('1.2.3')
    end
  end

  describe "#<=>" do
    it "compares correctly when the versions are differnt" do
      expect(Version.new('0.2') <=> Version.new('1.2')).to be -1
      expect(Version.new('1.2') <=> Version.new('0.2')).to be 1
      expect(Version.new('1.1') <=> Version.new('1.2')).to be -1
      expect(Version.new('1.2') <=> Version.new('1.1')).to be 1
      expect(Version.new('1.2.5') <=> Version.new('1.3.2')).to be -1
      expect(Version.new('1.3.2') <=> Version.new('1.2.5')).to be 1
    end
    it "compares correctly when the versions are the same" do
      v0 = Version.new('0')
      v1 = Version.new('1')
      v123 = Version.new('1.2.3')
      expect(v0 <=> Version.new('0')).to be 0
      expect(v1 <=> Version.new('1')).to be 0
      expect(v123 <=> Version.new('1.2.3')).to be 0
    end
    it "compares correctly when versions have different lengths" do
      expect(Version.new('1.2') <=> Version.new('1.2.3')).to be -1
      expect(Version.new('1.2.3') <=> Version.new('1.2')).to be 1
      expect(Version.new('1.2.0') <=> Version.new('1.2')).to be 0
      expect(Version.new('1.2') <=> Version.new('1.2.0')).to be 0
    end
  end

  describe "#components" do
    it "returns the components as an array" do
      expect(Version.new('1.2.3').components).to eq [1, 2, 3]
    end
    it "does not skip leading zeros" do
      expect(Version.new('0.0.2.3').components).to eq [0, 0, 2, 3]
    end
    it "skips trailing zeros" do
      expect(Version.new('1.2.3.0').components).to eq [1, 2, 3]
      expect(Version.new('1.2.3.0.0').components).to eq [1, 2, 3]
    end
    it "takes only the number of components that was requested" do
      expect(Version.new('1.2.3').components(2)).to eq [1, 2]
    end
    it "fills the remaining positions with zeros if it needs" do
      expect(Version.new('1.2.3').components(5)).to eq [1, 2, 3, 0, 0]
    end
    it "does not allow for changing the object" do
      version = Version.new('1.0.42')
      version.components.sort!
      expect(version.components).to eq [1, 0, 42]
    end
  end

  describe "Version::Range" do
    describe "#initialize" do
      it "initializes with empty strings" do
        range = Version::Range.new('', '')
        expect(range.to_a).to eq []
      end
      it "initializes from strings" do
        range = Version::Range.new('1.1', '1.1.5')
        expect(range.to_a).to eq VERSIONS
      end
      it "initializes with two instances of Version" do
        range = Version::Range.new(Version.new('1.1'), Version.new('1.1.5'))
        expect(range.to_a).to eq VERSIONS
      end
      it "initializes with combinations of Version instances and strings" do
        range1 = Version::Range.new(Version.new('1.1'), '1.1.5')
        expect(range1.to_a).to eq VERSIONS
        range2 = Version::Range.new('1.1', Version.new('1.1.5'))
        expect(range2.to_a).to eq VERSIONS
      end
    end

    describe "#include?" do
      let(:range) { Version::Range.new('1.1', '1.1.5') }
      it "accepts a string argument" do
        expect(range.include?('1.1.2')).to be true
      end
      it "includes the starting version" do
        expect(range.include?('1.1')).to be true
      end
      it "excludes the end version" do
        expect(range.include?('1.1.5')).to be false
      end
      it "accepts a Version instance as an argumnt" do
        expect(range.include?(Version.new('1.1.2'))).to be true
      end
      it 'fails if version is not in the range' do
        range = Version::Range.new('1.2.3', '1.5.1')
        expect(range.include?(Version.new('1.5.1'))).to be(false)
        expect(range.include?(Version.new('1.2.2'))).to be(false)
      end
    end

    describe "#to_a" do
      it "returns all version in the interval [start, end)" do
        range = Version::Range.new('1.1', '1.1.5')
        expect(range.to_a).to eq VERSIONS
      end
      it "increments all components in order" do
        range = Version::Range.new('0.9.8', '1.0.2')
        expect(range.to_a).to eq ['0.9.8', '0.9.9', '1', '1.0.1']
      end
      it "returns an empty array when start and end versions are the same" do
        range = Version::Range.new('1.1.5', '1.1.5')
        expect(range.to_a).to eq []
      end
    end
  end
end
