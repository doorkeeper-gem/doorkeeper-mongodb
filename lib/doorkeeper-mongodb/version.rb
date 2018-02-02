module DoorkeeperMongodb
  def self.gem_version
    Gem::Version.new VERSION::STRING
  end

  module VERSION
    # Semver
    MAJOR = 4
    MINOR = 0
    TINY = 0

    # Full version number
    STRING = [MAJOR, MINOR, TINY].compact.join('.')
  end
end
