module Utils
  def root
    '.'
  end

  def empty?(v)
    !v || (v.methods.include?(:empty?) && v.empty?)
  end

  def filenamize(name)
    name.gsub(/[^a-zA-Z0-9_\-\.\[\]\{\}\+]+/, '_')
  end
end
