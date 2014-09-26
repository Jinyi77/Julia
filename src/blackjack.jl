# To DO list:
# 1) allow ace to be 1 or 11
# 2) allow split & double down
# 3) build a dictionary to customized rules

#-------------------------------------------------------------------------------
function get_n_decks_cards(n::Int)
  cards = Array(Int, 0)
  card_value = [1:10]
  card_number = vcat(fill(4, 9), 16) * n

  for i in card_value
    for j = 1:card_number[i]
      push!(cards, i)
    end
  end

  return cards
end

#-------------------------------------------------------------------------------
function shuffle_cards(cards::Vector)
  # shuffle cards fairly!
  return cards[randperm(size(cards, 1)), 1]
end

#-------------------------------------------------------------------------------
function set_up_table(n_p::Int)
  return table_cards = zeros(Int, n_p + 1) # leave the last seat for dealer here
end

#-------------------------------------------------------------------------------
function decide_player_action(player_cards::Int, dealer_faced_up_card::Int)
  # need to build a dictionary to make these rules customized
  if 12 <= player_cards <= 16
    ans = 2 <= dealer_faced_up_card <= 6 ? "stand" : "hit"
  elseif  player_cards > 21
    ans = "bust"
  elseif 17 <= player_cards <= 21
    ans = "stand"
  elseif 10 <= player_cards <= 11
    ans = 2 <= dealer_faced_up_card <= 6 ? "doubledown" : "hit"
  else
    ans = "hit"
  end

  return ans
end

#-------------------------------------------------------------------------------
function decide_dealer_action(dealer_cards::Int)
  # will build a dictionary to make these rules customized
  if dealer_cards <= 16
    ans = "hit"
  elseif 17 <= dealer_cards <= 21
    ans = "stand"
  else
    ans = "bust"
  end

  return ans
end

#-------------------------------------------------------------------------------
function send_off_cards(cards::Vector, table_cards::Vector)
  # first round
  for i = 1:size(table_cards, 1)
    table_cards[i] = cards[i] + cards[i + size(table_cards, 1)]
  end

  # each player acts and makes decision
  dealer_faced_up_card = cards[size(table_cards, 1)]
  ind_card = 2 * size(table_cards, 1) + 1
  for i = 1:size(table_cards, 1)-1
    action = decide_player_action(table_cards[i], dealer_faced_up_card)
    while !(action in ["stand", "bust"])
      table_cards[i] += cards[ind_card]
      action = decide_player_action(table_cards[i], dealer_faced_up_card)
      ind_card += 1
    end

    if action == "bust"
      table_cards[i] = -1
    end

  end

  # dealer acts and makes decision
  action = decide_dealer_action(table_cards[end])
  while !(action in ["stand", "bust"])
    table_cards[end] += cards[ind_card]
    action = decide_dealer_action(table_cards[end])
    ind_card += 1
  end

  if action == "bust"
    table_cards[end] = 0
  end

  return table_cards
end

#-------------------------------------------------------------------------------
function get_result(table_cards::Vector)
  result = fill("tie", size(table_cards, 1)-1)
  for i = 1:size(table_cards, 1)-1
    if table_cards[i] > table_cards[end]
      result[i] = "win"
    elseif table_cards[i] < table_cards[end]
      result[i] = "loss"
    end
  end

  return result
end

#-------------------------------------------------------------------------------
function play_game(n_decks::Int, n_players::Int)
  cards = shuffle_cards(get_n_decks_cards(n_decks))
  init_table_cards = set_up_table(n_players)
  table_cards = send_off_cards(cards, init_table_cards)
  result = get_result(table_cards)
  return result
end
#-------------------------------------------------------------------------------
