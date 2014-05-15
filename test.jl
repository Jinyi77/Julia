# Calculate the ratio of win, loss and tie for each player against dealer using
# MCMC

n_decks, n_players =  1, 3
n_simulations = 100000
n_wins = zeros(Int, n_players)
n_ties = zeros(Int, n_players)
n_losses = zeros(Int, n_players)

for k = 1:n_simulations
  result = play_game(n_decks, n_players)
  for i = 1:n_players
    if result[i] == "win"
      n_wins[i] += 1
    elseif result[i] == "loss"
      n_losses[i] += 1
    elseif result[i] == "tie"
      n_ties[i] += 1
    else
      println("Unexpected Result!!")
    end
  end
end

println(n_losses / n_simulations)
println(n_wins / n_simulations)
