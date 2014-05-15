function beta_generator(a::Float64, b::Float64, n::Int)

  vector = zeros(n)
  count = 1
  # when a and b are less than 1
  if a < 1.0 && b < 1.0
    while count <= n
      u1, u2 = rand(), rand()
      x, y = u1^(1.0 / a), u2^(1.0 / b)
      if x + y <= 1.0
        vector[count] = x / (x + y)
        count += 1
      end
    end

  elseif  a == ceil(a) && b == ceil(b)
    for count = 1:n
      vector[count] = sort(rand(convert(Int, a + b + 1)))[a]
    end
  else
    vector = (rand(Gamma(1.0, a), n) ./(rand(Gamma(1.0, a), n)
              + rand(Gamma(1.0, b), n)))
  end

  return vector
end
