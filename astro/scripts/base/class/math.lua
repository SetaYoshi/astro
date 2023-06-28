function math.clamp(min, max, x)
  return math.min(max, math.max(min, x))
end

function math.sign(x)
  return x > 0 and 1 or (x == 0 and 0 or -1)
end