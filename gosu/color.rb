class Gosu::Color
  def filter_by_tint(r, g, b, a)
    tint_r = r * a
    tint_g = g * a
    tint_b = b * a
    alpha_inv = (1 - a).to_f
    self.red   = self.red   * alpha_inv + r * a
    self.green = self.green * alpha_inv + g * a
    self.blue  = self.blue  * alpha_inv + b * a
    return self
  end
end
