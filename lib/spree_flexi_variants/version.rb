module SpreeFlexiVariants
  VERSION = '4.6.6'.freeze

  module_function

  # Returns the version of the currently loaded SpreeFlexiVariants as a
  # <tt>Gem::Version</tt>.
  def version
    Gem::Version.new VERSION
  end
end
